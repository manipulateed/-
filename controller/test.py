import re
# 處理GPT生成方向文字轉LIST
def process_response(response):
    print("In process response")
    matches = re.findall(r'"([^"]+)"', response)
    #print("matches: ")
    return matches

result = process_response("\"手臂拉伸動作\" \"正確打羽球姿勢\"\"緩解手臂肌肉緊繃\"\"熱敷緩解肌肉疼痛\"\"手臂收操動作\"")

print("keywords:" +result)