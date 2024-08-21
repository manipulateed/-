from flask import Flask, request, jsonify, redirect, url_for, Blueprint
from langchain_core.prompts import (
    ChatPromptTemplate,
    MessagesPlaceholder,
    SystemMessagePromptTemplate,
    HumanMessagePromptTemplate,
)
from dotenv import load_dotenv
from langchain.schema import HumanMessage
from langchain.chains import LLMChain
from langchain.chains.summarize import load_summarize_chain
#from langchain.chains import RunnableSequence
from langchain_openai import ChatOpenAI
from datetime import datetime
#from langchain_chroma import Chroma
from langchain_openai import OpenAIEmbeddings

from langchain.memory import ConversationBufferMemory
import os
import requests
import json
import re
from models.Message import Message
from .VideoController import search_and_create_videos

# 在應用啟動時加載 .env 文件
load_dotenv() 

#建立聊天控制器藍圖
callGPT_bp = Blueprint('callGPT', __name__)

# 設置 API_Key
API_KEY = os.getenv('API_KEY')

#建構聊天model
chat = ChatOpenAI(model = "ft:gpt-3.5-turbo-0125:personal::9iHcUIlX", api_key = API_KEY)

#建構記憶工具
memory = ConversationBufferMemory(memory_key="chat_history", return_messages=True)

#診斷用之提示工程
prompt_diagnose = ChatPromptTemplate(
        messages=[
            SystemMessagePromptTemplate.from_template(
                """
                You are a professional who excels in deducing the cause of user discomfort.

                Please follow these steps to diagnose my pain, asking only one question at a time:
                First, ask me where I feel pain.
                Secondly,econdly,deduce the possible muscles in that area to figure out why I might be experiencing this pain.
                Third,make some initial guesses, and then ask me questions based on the possible causes, but ask only one question at a time.
                Fourth,gradually, through a series of questions and answers, understand why I am experiencing muscle pain.Feel free to ask me various questions, including about my lifestyle, any exercises I have done recently, how long I have been feeling the pain, and the nature of the pain. Ask anything that might help you make a deduction, but try to avoid open-ended questions since I am not an expert in this field.
                Last,Based on our conversation, deduce the possible cause or symptoms like a professional doctor. You can also mention specific muscle areas.
                
                You can also refer to the Nordic Musculoskeletal Questionnaire to check muscle conditions in various parts of the body and assess work-related injuries, 
                or ask me to perform certain movements to help with your judgment.

                Before making a judgment, please judge the possible causes based on {question} and ask user some questions to do the elimination method to judge the conclusion.           
                #zh_TW
                
                """
            ),
            # The variable_name here is what must align with memory
            MessagesPlaceholder(variable_name="chat_history"),
            HumanMessagePromptTemplate.from_template("{question}")
        ]
    )

#推薦影片方向用之提示工程
prompt_direction = ChatPromptTemplate(
        messages=[
            SystemMessagePromptTemplate.from_template(
                """
                You are a professional doctor who excels in deducing the cause of user discomfort.
                Based on the summary, deduce possible causes or symptoms like a professional doctor and suggest different areas they can focus on to relieve their discomfort, 
                such as related body part "stretching exercises," "heat therapy," "posture improvement," "preventive movements," "muscle exercises," etc.
                You can also suggest other relevant methods you think could be useful for querying and improving the user's symptoms.
                These suggestions will be used as YouTube search keywords to obtain more detailed information or videos.
                Therefore, please make the suggestions more complete and add "the reason for the user's pain" or "discomfort area" to make it easier to search for related content on YouTube.

                Example:
                user input:
                "The human mentions experiencing neck and shoulder pain. The AI asks if the human has been spending long hours on the computer or using a phone recently. The human responds "no." The AI then asks if the human has been doing any heavy lifting or shoulder-related exercises recently. The human says they went surfing for the first time yesterday. The AI suggests that surfing could cause shoulder and back muscle pain and asks if the human frequently looked up at the sky or raised their arms while learning to surf. The human says they frequently raised their arms and looked up while surfing. The AI inquires whether the pain is constant or only felt during specific movements. 當你昨天第一次衝浪時，頻繁舉起雙手並抬頭看天空，可能導致肩膀和背部肌肉疼痛。建議專注於舒緩肩膀和背部肌肉的方法"            
                
                assistant:
                "手臂拉伸動作" 
                "正確衝浪運動姿勢"
                "緩解手臂肌肉緊繃"
                "熱敷緩解肌肉疼痛"
                "手臂收操動作"
                "熱敷治療手臂僵硬"
                "正確坐姿"
                "防止肩膀疼痛"
                "冰敷緩解肌肉疼痛"
                "手臂疼痛冰敷方法"
                "手臂疼痛的水療方法"
                "水療緩解肌肉疼痛"
                "冥想放鬆肌肉"
                "物理治療緩解手臂疼痛"

                請只用中文回答我，並且像example一樣，給出5個左右不同的有用的建議方向，之後請幫我一個一個放入""中，並用換行符號換行顯示，給我5個左右有用的建議方向。
                
                """
            ),
            # The variable_name here is what must align with memory
            MessagesPlaceholder(variable_name="chat_history"),
            HumanMessagePromptTemplate.from_template("{question}")
        ]
    )

#建構診斷用之功能Chain
conversation_diagnose = LLMChain(
    llm=chat,
    prompt=prompt_diagnose,
    verbose=True,
    memory=memory
)

#建構推薦影片方向用之功能Chain
conversation_direction = LLMChain(
        llm=chat,
        prompt=prompt_direction,
        verbose=True,
        memory=memory
    )

#YT search function
def search_YT_video(keyword):

    url = "https://www.googleapis.com/youtube/v3/search?key=AIzaSyBtqh_uCgnbs9iC6mW9g-mzyGt1Zmpwz8U&q="+keyword+"&type=video&part=snippet&maxResults=2"

    payload = {}
    headers = {}

    response = requests.request("GET", url, headers=headers, data=payload)

    result = response.json()

    videos = []
    for item in result.get("items", []):
        video_id = item["id"]["videoId"]
        title = item["snippet"]["title"]
        description = item["snippet"]["description"]
        video_url = f"https://www.youtube.com/watch?v={video_id}"
        videos.append({"title": title, "description": description, "url": video_url})

    return videos

# 處理GPT生成方向文字轉LIST
def process_response(response):

    response = response['text'] 
    matches = re.findall(r'"([^"]+)"', response)
    #print("matches: ")
    return matches

#診斷控制器路由
@callGPT_bp.route('/diagnose', methods=['POST'])
def diagnose():
    #處理POST所傳的data
    data = request.json
    user_input = data.get("user_input")

    #丟給GPT生成回應
    response = conversation_diagnose.invoke({"question": user_input})
    response_text = response['text']

    #建構訊息model  
    message = Message(
        character = "AI",
        content = response_text,
        date = datetime.now().strftime("%Y-%m-%d"),
        time = datetime.now().strftime("%H:%M:%S")
    )

    # Check if we need to stop the diagnosis loop
    if "尋求專業醫師" in response_text:
        return summary(response_text)

    return jsonify({"response": message.get_Message_data(), "end": False})

#推薦方向控制器路由
@callGPT_bp.route('/summary', methods=['GET'])
def summary(message):

    #取得聊天記憶並生成推薦影片方向
    chat_history = memory.load_memory_variables({})["chat_history"]
    response = conversation_direction.invoke({"question": chat_history})
    
    #建構訊息model
    message1 = Message(
            character = "AI",
            content = message,
            date = datetime.now().strftime("%Y-%m-%d"),
            time = datetime.now().strftime("%H:%M:%S")
        )
    
    #處理關鍵字
    suggested_Videos = []
    keywords_list = process_response(response)
    print(keywords_list)
    
    #蝶帶關鍵詞列表，並調用 search_YT_video 函数
    for keyword in keywords_list:
        data = {"keyword" : keyword, "max_results": 5}
        app = Flask(__name__)
        app.register_blueprint(callGPT_bp)
        with app.test_request_context(f'/api/video/search_and_create'):
            
            # 直接調用 search_and_create_videos 並傳入參數
            response = search_and_create_videos(data)
            
            # 假設 search_and_create_videos 回傳一個字典
            # 將結果轉為字典並取得 all_videos
            if response["success"]:

                video_ids = [video["video_id"] for video in response["all_videos"]]
                suggested_Videos.append({"Keyword": keyword,
                                "Video_id": video_ids})
            else:
                print(response['message'])

    #清除記憶資料    
    memory.clear()

    return jsonify({"Suggested_Videos": suggested_Videos, "end": True, "response": message1.get_Message_data()})

