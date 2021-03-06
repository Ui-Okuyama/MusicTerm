//
//  Comment.swift
//  MusicTermApp
//
//  Created by 槙和馬 on 2021/10/18.
//

import Foundation

struct Comment {
    var comment : String
    var scoreRange = 0
    let commentData = [
        "Mozart" : ["まずは努力が大事だ","まだまだ学ぶことができる！","認められるには努力が必要だ","学ぶことは楽しいだろう！","素晴らしい！！","なんてことだ！すごい！"],
        "Beethoven" : ["自らの力で自らを切り開け！","苦悩を突き抜ければ喜びを勝ち得る","どんな難問だろうと打ち勝ってみせよう","誰も君の努力を邪魔することはできない","ついにここまできたか…！","これほど嬉しいことがあるだろうか！！"],
        "Bach" : ["勉強して出直してこい！","勤勉でいれば、上手くいく。","誰でも努力すれば私ほどになれるんだ！","どんな難問でも解けなければならない","神は私たちの努力を見守ってくださっている","よくここまでやった！！"],
        "Debussy" : ["家族のもとに帰りたい…","自分の信念に従えば良い","こういう勉強の話は苦手だ","フランス語の楽語も覚えてほしいな","…すごいな","素晴らしい"],
        "Tchaikovsky" : ["怠けている暇はない…","道のりはまだ程遠い。","悩ましい…","まだまだ勉強しなくてはならない","よくここまでたどり着いた！！","素晴らしい…！"],
        "Chopin" : ["体調が悪い…","これからも精進したまえ","君はちゃんと勉強しているのかね？","まあ、平均的な音楽家というところか。","なかなか筋がいいじゃないか","見事だ。"],
        "Schubert" : ["これは、この先大変だなぁ…","まだまだ勉強しなくてはな","良くなったな！","頑張ったな！","すごい！！！","飛び抜けている！！！"],
        "Brahms" : ["君には努力する才能が必要だな","少しはマシになった","これくらいで油断するんじゃない","…まあまあだな","…まあいいじゃないか","素晴らしい…！"],
        "Schumann" : ["ひどい有様だ…！","まだまだだな…","なんとか基本はできるようになったな","まあ合格点といったところか。","ドイツ語は美しい言葉が多い！覚えてくれ！","素晴らしい！！天才的だ！！"],
        "Haydn" : ["速度変化など基本的なことから覚えていこう","まだまだ覚える単語はある","間違った楽語を見直そう","よくできている！","素晴らしい！さらに上を目指そう","すごい！君は一人前の楽語マスターだ"],
        "Ravel" : ["左右違う靴を履くくらいひどい出来だ","これからもその調子で学びたまえ","細部までよく見ろ、服もそうするだろう？","それで普通なくらいだ","美しいフランス語も覚えてくれ","最高だ！"],
        "Liszt" : ["君はきっと、やればできるよ","その調子！一生懸命な君は素敵だ","僕と一緒に勉強していかないか","すごいじゃないか！","素晴らしいな、頑張る君の姿は美しい","君は最高だ！"],
        "Paganini" : ["フン！聞いて呆れる","私は練習で忙しいんだ","金を寄越さないなら教えん。","まだまだ通用しないよ","君が8万点を越えるか賭けをしていたのに…","大負けだ！これでは私の楽器が取られる！"],
        "Mendelssohn" : ["頑張れ！君ならできるよ","頑張ったね！","焦らず少しずつ覚えていこう","君ならできると思っていたよ！","すごいじゃないか！","素晴らしい！僕も頑張らなくちゃね"],
        "Handel" : ["まあまあ気にしなさんな、ハハハ","まだまだこの先も大変だぞ","これからもがんばれ！","なかなかいいじゃないか！ハハハ","すごいなぁ、見直したぞ！","素晴らしい！感激だ！"],
        "Grieg" : ["これから努力すればいい","頑張っているね","少しずつ覚えていけば大丈夫だ、焦らずに。","すごいじゃないか、努力が報われたね","見事だったよ","おぉ、なんと素晴らしい…"],
        "Saint-Saens" : ["ほー、、、","不十分だ","ほー、その程度かね","まあ普通だな","やっと通じるくらいだな","ふん、なかなかいいではないか"],
        "Prokofiev" : ["努力を怠らないように","まだ道のりは遠い","少しずつ覚えていこう","良くなったね","素晴らしい！！","最高だ！！"]
    ]
    
    init(composer: String, score: Int) {
        switch score {
        case 0 ..< 7000 : scoreRange = 0
        case 7000 ..< 22000 : scoreRange = 1
        case 22000 ..< 35000 : scoreRange = 2
        case 35000 ..< 80000 : scoreRange = 3
        case 80000 ..< 100000 : scoreRange = 4
        case 100000 ..< 1000000 : scoreRange = 5
        default: scoreRange = 3
        }
        comment = commentData[composer]![scoreRange]
    }
}
