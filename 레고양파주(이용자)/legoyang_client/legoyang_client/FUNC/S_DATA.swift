//
//  S_DATA.swift
//  legoyang_owner
//
//  Created by 장 제현 on 2022/12/13.
//

import UIKit

var DF = DateFormatter()
var NF = NumberFormatter()

let CATEGORY_IMAGES: [String: String] = [
    "놀이": "cate_play",
    "대관대여": "cate_rental",
    "맛집": "cate_restaurant",
    "문화": "cate_culture",
    "뷰티": "cate_beauty",
    "애견": "cate_dog",
    "액티비티": "cate_activity",
    "운동": "cate_exercise",
    "주점": "cate_pub",
    "카페": "cate_cafe",
    "키즈존": "cate_kidszone",
    "풀빌라펜션": "cate_pension",
    "행사": "cate_event",
    "호텔": "cate_hotel",
]

let GOYANG_PAJU_SI: [String: [String]] = [
    "고양시 덕양구": [
        "고양동",
        "관산동",
        "능곡동",
        "대덕동",
        "삼송동",
        "원신동",
        "성사1동",
        "성사2동",
        "주교동",
        "창릉동",
        "행신1동",
        "행신2동",
        "행신3동",
        "행주동",
        "화전동",
        "화정1동",
        "화정2동",
        "효자동",
        "흥도동"
    ],
    "고양시 일산서구": [
        "가좌동",
        "대화동",
        "덕이동",
        "송포동",
        "일산1동",
        "일산2동",
        "일산3동",
        "주엽1동",
        "주엽2동",
        "탄현1동",
        "탄현2동"
    ],
    "고양시 일산동구": [
        "고봉동",
        "마두1동",
        "마두2동",
        "백석1동",
        "백석2동",
        "식사동",
        "장항1동",
        "장항2동",
        "정발산동",
        "중산1동",
        "중산2동",
        "풍산동"
    ],
    "파주시": [
        "금촌동",
        "아동동",
        "야동동",
        "검산동",
        "맥금동",
        "교하동",
        "야당동",
        "다율동",
        "오도동",
        "상지석동",
        "산남동",
        "동패동",
        "당하동",
        "문발동",
        "송촌동",
        "목동동",
        "하지석동",
        "서패동",
        "신촌동",
        "연다산동",
        "와동동",
        "금릉동",
        "문산읍",
        "파주읍",
        "법원읍",
        "조리읍",
        "월롱면",
        "탄현면",
        "광탄면",
        "파평면",
        "적성면",
        "군내면",
        "장단면",
        "진동면",
        "진서면",
        "금촌1동",
        "금촌2동",
        "금촌3동",
        "운정1동",
        "운정2동",
        "운정3동"
    ]
]

let DELIVERY_COMPANY: [String: String] = [
    "천일택배": "kr.chunilps",
    "CJ대한통운": "kr.cjlogistics",
    "CU 편의점택배": "kr.cupost",
    "GS Postbox 택배": "kr.cvsnet",
    "CWAY (Woori Express)": "kr.cway",
    "대신택배": "kr.daesin",
    "우체국 택배": "kr.epost",
    "한의사랑택배": "kr.hanips",
    "한진택배": "kr.hanjin",
    "합동택배": "kr.hdexp",
    "홈픽": "kr.homepick",
    "한서호남택배": "kr.honamlogis",
    "일양로지스": "kr.ilyanglogis",
    "경동택배": "kr.kdexp",
    "건영택배": "kr.kunyoung",
    "로젠택배": "kr.logen",
    "롯데택배": "kr.lotte"
]
