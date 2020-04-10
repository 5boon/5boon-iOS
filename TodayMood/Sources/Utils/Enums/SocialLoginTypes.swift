//
//  SocialLoginTypes.swift
//  TodayMood
//
//  Created by Kanz on 2020/03/14.
//

enum SocialLoginTypes: CaseIterable {
    case kakao
    case google
    case naver
    case facebook
    case apple
    
    var iconImageName: String {
        switch self {
        case .kakao:
            return "img_kakaologin"
        case .google:
            return "img_facebooklogin"
        case .naver:
            return "img_naverlogin"
        case .facebook:
            return "img_facebooklogin"
        case .apple:
            return "img_applelogin"
        }
    }
    
    var title: String {
        switch self {
        case .kakao:
            return "카카오톡으로 로그인"
        case .google:
            return "구글 계정으로 로그인"
        case .naver:
            return "네이버로 로그인"
        case .facebook:
            return "페이스북으로 로그인"
        case .apple:
            return "애플 로그인"
        }
    }
}
