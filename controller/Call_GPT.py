from flask import Flask, request, jsonify, Blueprint
from flask_jwt_extended import jwt_required, get_jwt_identity
from langchain_core.prompts import (
    ChatPromptTemplate,
    MessagesPlaceholder,
    SystemMessagePromptTemplate,
    HumanMessagePromptTemplate,
    PromptTemplate,
)
from dotenv import load_dotenv
from langchain_core.runnables.history import RunnableWithMessageHistory
from langchain.chains import LLMChain
#from langchain.chains import RunnableSequence
from langchain_openai import ChatOpenAI
from datetime import datetime
#from langchain_chroma import Chroma
from langchain_openai import OpenAIEmbeddings
from langchain_mongodb.chat_message_histories import MongoDBChatMessageHistory
import os
import requests
import json
import re
from models.Message import Message
from .VideoController import search_and_create_videos
import logging
from .Sour_Record_Controller import create_sour_record

# 配置日誌
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

# 在應用啟動時加載 .env 文件
load_dotenv() 

#建立聊天控制器藍圖
callGPT_bp = Blueprint('callGPT', __name__)

# 設置 環境變數
API_KEY = os.getenv('API_KEY')
MONGODB_URI = os.getenv('MONGODB_URI')
MONGODB_DATABASE = os.getenv('MONGODB_DATABASE')
MONGODB_COLLECTION = 'chat_histories'

#建構聊天model
chat = ChatOpenAI(model = "ft:gpt-3.5-turbo-0125:personal::9iHcUIlX", api_key = API_KEY)

#建構summary promtp
prompt_template = """Use #zh_TW to write a concise summary within 30 to 50 words of the following:
"{text}" to describe the User's situation.
CONCISE SUMMARY:"""
prompt = PromptTemplate.from_template(prompt_template)
llm = ChatOpenAI(temperature=0, model_name="gpt-3.5-turbo-0125", api_key = API_KEY)
llm_chain = prompt | llm

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
chain = prompt_diagnose | chat

#建構推薦影片方向用之功能Chain
chain_direction = prompt_direction | llm

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
    print("In process response")
    matches = re.findall(r'"([^"]+)"', response)
    #print("matches: ")
    return matches

#診斷控制器路由
@callGPT_bp.route('/diagnose', methods=['POST'])
@jwt_required()
def diagnose():
    #處理POST所傳的data
    data = request.json
    user_input = data.get("user_input")

    # 從請求的標頭中提取 Authorization 標頭，並打印 token
    auth_header = request.headers.get('Authorization')
    if auth_header:
        token = auth_header.split()[1]  # Authorization: Bearer <token>
        print(f"JWT Token: {token}")  # 打印獲得的 JWT token
    
    current_user_id = get_jwt_identity()
    print(f"JWT Identity (current_user_id): {current_user_id}")  # 打印取得的 current_user_id
    user_id = current_user_id

    CR_id = data.get("CR_id")  # 確保前端傳遞 CR_id

    if not CR_id:
        return jsonify({"error": "CR_id 是必需的"}), 400
    if not user_input:
        return jsonify({"error": "user_input 是必需的"}), 400

    try:
        # 將記憶體注入到 Chain 中，建構診斷用之功能Chain
        chain_with_history = RunnableWithMessageHistory(
            chain,
            lambda session_id: MongoDBChatMessageHistory(
                session_id=session_id,
                connection_string=MONGODB_URI,
                database_name=MONGODB_DATABASE,
                collection_name=MONGODB_COLLECTION
            ),
            input_messages_key="question",
            history_messages_key="chat_history",
        )
    except Exception as e:
        print(f"無法連接到 MongoDB：{e}")
        logger.error(f"無法連接到 MongoDB：{e}")
        raise

    #丟給GPT生成回應
    try:
        config = {"configurable": {"session_id": CR_id}}
        response = chain_with_history.invoke({"question": user_input},config=config)
        response_text = response.content
    except Exception as e:
        print(f"LLMChain 錯誤：{e}")
        logger.error(f"LLMChain 錯誤：{e}")
        return jsonify({"error": "處理請求時發生錯誤"}), 500

    #建構訊息model  
    message = Message(
        character = "AI",
        content = response_text,
        date = datetime.now().strftime("%Y-%m-%d"),
        time = datetime.now().strftime("%H:%M:%S")
    )

    # Check if we need to stop the diagnosis loop
    if "尋求專業醫師" in response_text or "尋求專業醫生" in response_text:
        return create_summary_response(message, CR_id, token)

    return jsonify({"response": message.get_Message_data(), "end": "False"})

def create_summary_response(message, CR_id, token):
    try:
        # 從記憶體中載入聊天歷史
        chat_history = MongoDBChatMessageHistory(
            session_id = CR_id,
            connection_string = MONGODB_URI,
            database_name = MONGODB_DATABASE,
            collection_name = MONGODB_COLLECTION
        )

        with_history = RunnableWithMessageHistory(
            chain_direction,
            lambda session_id: MongoDBChatMessageHistory(
                session_id=session_id,
                connection_string=MONGODB_URI,
                database_name=MONGODB_DATABASE,
                collection_name=MONGODB_COLLECTION
            ),
            input_messages_key="question",
            history_messages_key="chat_history",
        )

        config = {"configurable": {"session_id": CR_id}}
        #獲取推薦廣度關鍵字
        response = with_history.invoke({"question": chat_history.messages}, config = config).content

        #獲取痠痛摘要
        result = llm_chain.invoke({"text": chat_history.messages}).content

        #處理關鍵字
        suggested_Videos = []
        keywords_list = process_response(response)
        
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
                    print("Get Videos Success")
                    video_ids = [video["video_id"] for video in response["all_videos"]]
                    print("Extract this keyword to the videos id.")
                    suggested_Videos.append({"Keyword": keyword,
                                    "Video_id": video_ids})
                else:
                    print(response['message'])

        #Add Sour Record
        app = Flask(__name__)
        app.register_blueprint(callGPT_bp)
        from flask_jwt_extended import JWTManager
        # 配置 JWT 機制
        app.config['JWT_SECRET_KEY'] = os.getenv('JWT_SECRET_KEY')
        jwt = JWTManager(app)

        # 模擬測試上下文來呼叫 `/Sour_Record_Controller/create` 路由
        with app.test_request_context(
            '/Sour_Record_Controller/create',
            method='POST',  # 指定方法為 POST
            json={
                "reason": result,  # 這裡的 `result` 應該是你定義的變數
                "time": datetime.now().strftime("%Y-%m-%d"),
                "videos": suggested_Videos  # `suggested_Videos` 應該是你定義的變數
            },
            headers={
                "Authorization": f"Bearer {token}",  # 確保 token 是正確生成的
                "Content-Type": "application/json"
            }
        ):
            # 直接調用路由函數 `create_sour_record`
            response = create_sour_record()  # 確保這個函數已正確匯入

            # 假設路由函數返回一個 JSON 回應，轉為字典並處理
            if response["success"]:
                print("成功:", response["message"])
            else:
                print("失敗:", response["message"])


        # 清理使用者記憶
        chat_history.clear()

        return jsonify({
                "Suggested_Videos": suggested_Videos,
                "end": "True",
                "response": message.get_Message_data()
            })

    except Exception as e:
        logger.error(f"出錯囉：{e}")
        return jsonify({"error": f"出錯囉：{e}"}), 500