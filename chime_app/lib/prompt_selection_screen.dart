import 'package:chime_app/language_selection_model.dart';
import 'package:flutter/material.dart';
import 'package:chime_app/shared/widgets/prompt_tile.dart';
import 'package:chime_app/shared/widgets/buttons.dart';
import 'package:chime_app/chat_screen.dart';
import 'package:provider/provider.dart';

class PromptSelectionScreen extends StatefulWidget {
  const PromptSelectionScreen({Key? key}) : super(key: key);

  @override
  PromptSelectionScreenState createState() => PromptSelectionScreenState();
}

class PromptSelectionScreenState extends State<PromptSelectionScreen> {
  String? _selectedPromptTitle;

  @override
  Widget build(BuildContext context) {
    // Can generate different prompts automatically? Or maintain consistency
    // To-do: Add a skip button
    Map<String, List<Map<String, String>>> prompts = {
      "Spanish": [
        {
          'title': 'Tell Chime about your day...',
          'subtitle':
              'Buenas noches! ¿Qué tal tu día de hoy? ¿Hiciste algo divertido anoche?',
        },
        {
          'title': 'Order food at a restaurant...',
          'subtitle':
              'Bienvenidos al Sol y Sabor. Tenemos tacos, quesadillas, y burritos. ¿Qué quiere pedir?',
        },
        {
          'title': 'Buy something at the market...',
          'subtitle': '¡Compre zapatos a 400 pesos!',
        },
        {
          'title': 'Jump into that business meeting...',
          'subtitle':
              'Para comenzar, vamos a analizar las tendencias actuales del mercado.',
        },
      ],
      "Chinese": [
        {
          'title': 'Tell Chime about your day...',
          'subtitle': '晚上好！你今天过得怎么样？昨晚做了什么有趣的事吗？',
        },
        {
          'title': 'Order food at a restaurant...',
          'subtitle': '欢迎光临阳光与味道。我们有宫保鸡丁、麻婆豆腐和春卷。您想点些什么？',
        },
        {
          'title': 'Buy something at the market...',
          'subtitle': '在市场上买鞋子，只需300元！',
        },
        {
          'title': 'Jump into that business meeting...',
          'subtitle': '首先，我们来分析一下当前的市场趋势。',
        },
      ],
      "English": [
        {
          'title': 'Tell Chime about your day...',
          'subtitle':
              'Good evening! How was your day today? Did you do anything fun last night?',
        },
        {
          'title': 'Order food at a restaurant...',
          'subtitle':
              'Welcome to Sun and Flavor. We have fish and chips, shepherd’s pie, and Sunday roast. What would you like to order?',
        },
        {
          'title': 'Buy something at the market...',
          'subtitle': 'Buy shoes for 50 pounds!',
        },
        {
          'title': 'Jump into that business meeting...',
          'subtitle':
              'To start, we\'re going to analyze the current market trends.',
        },
      ],
      "French": [
        {
          'title': 'Tell Chime about your day...',
          'subtitle':
              'Bonne soirée ! Comment s’est passée ta journée ? As-tu fait quelque chose d’amusant hier soir ?',
        },
        {
          'title': 'Order food at a restaurant...',
          'subtitle':
              'Bienvenue chez Soleil et Saveur. Nous avons du coq au vin, du cassoulet, et des crêpes. Que désirez-vous commander ?',
        },
        {
          'title': 'Buy something at the market...',
          'subtitle': 'Achetez des chaussures pour 100 euros !',
        },
        {
          'title': 'Jump into that business meeting...',
          'subtitle':
              'Pour commencer, nous allons analyser les tendances actuelles du marché.',
        },
      ],
      "German": [
        {
          'title': 'Tell Chime about your day...',
          'subtitle':
              'Guten Abend! Wie war dein Tag heute? Hast du gestern Abend etwas Lustiges gemacht?',
        },
        {
          'title': 'Order food at a restaurant...',
          'subtitle':
              'Willkommen bei Sonne und Geschmack. Wir haben Schnitzel, Bratwurst und Sauerkraut. Was möchten Sie bestellen?',
        },
        {
          'title': 'Buy something at the market...',
          'subtitle': 'Kaufen Sie Schuhe für 100 Euro!',
        },
        {
          'title': 'Jump into that business meeting...',
          'subtitle':
              'Zunächst werden wir die aktuellen Markttrends analysieren.',
        },
      ],
      "Hindi": [
        {
          'title': 'Tell Chime about your day...',
          'subtitle':
              'शुभ संध्या! आपका दिन आज कैसा रहा? क्या आपने कल रात कुछ मजेदार किया?',
        },
        {
          'title': 'Order food at a restaurant...',
          'subtitle':
              'सूर्य और स्वाद में आपका स्वागत है। हमारे पास बटर चिकन, पालक पनीर, और छोले भटूरे हैं। आप क्या ऑर्डर करना चाहेंगे?',
        },
        {
          'title': 'Buy something at the market...',
          'subtitle': 'बाजार में 2000 रुपये में जूते खरीदें!',
        },
        {
          'title': 'Jump into that business meeting...',
          'subtitle':
              'शुरू करने के लिए, हम वर्तमान बाज़ार प्रवृत्तियों का विश्लेषण करेंगे।',
        },
      ],
      "Italian": [
        {
          'title': 'Tell Chime about your day...',
          'subtitle':
              'Buonasera! Come è andata la tua giornata? Hai fatto qualcosa di divertente ieri sera?',
        },
        {
          'title': 'Order food at a restaurant...',
          'subtitle':
              'Benvenuti a Sole e Sapore. Abbiamo pizza, pasta e gelato. Cosa desiderate ordinare?',
        },
        {
          'title': 'Buy something at the market...',
          'subtitle': 'Compra scarpe per 100 euro!',
        },
        {
          'title': 'Jump into that business meeting...',
          'subtitle':
              'Per iniziare, analizzeremo le tendenze di mercato attuali.',
        },
      ],
      "Norwegian": [
        {
          'title': 'Tell Chime about your day...',
          'subtitle':
              'God kveld! Hvordan har dagen din vært? Gjorde du noe morsomt i går kveld?',
        },
        {
          'title': 'Order food at a restaurant...',
          'subtitle':
              'Velkommen til Sol og Smak. Vi har laks, kjøttkaker og brunost. Hva vil du bestille?',
        },
        {
          'title': 'Buy something at the market...',
          'subtitle': 'Kjøp sko for 1000 kroner!',
        },
        {
          'title': 'Jump into that business meeting...',
          'subtitle':
              'For å starte, skal vi analysere de nåværende markeds-trendene.',
        },
      ],
      "Thai": [
        {
          'title': 'Tell Chime about your day...',
          'subtitle':
              'สวัสดีตอนเย็น! วันนี้ของคุณเป็นอย่างไรบ้าง? เมื่อคืนคุณทำอะไรสนุกๆ ไหม?',
        },
        {
          'title': 'Order food at a restaurant...',
          'subtitle':
              'ยินดีต้อนรับสู่ สุริยาและรสชาติ เรามีต้มยำกุ้ง, ผัดไทย, และข้าวมันไก่ คุณต้องการสั่งอะไร?',
        },
        {
          'title': 'Buy something at the market...',
          'subtitle': 'ซื้อรองเท้าในราคา 1000 บาท!',
        },
        {
          'title': 'Jump into that business meeting...',
          'subtitle': 'เริ่มต้น, เราจะวิเคราะห์แนวโน้มตลาดปัจจุบัน.',
        },
      ],
      "Vietnamese": [
        {
          'title': 'Tell Chime about your day...',
          'subtitle':
              'Chào buổi tối! Ngày hôm nay của bạn thế nào? Bạn có làm điều gì thú vị tối qua không?',
        },
        {
          'title': 'Order food at a restaurant...',
          'subtitle':
              'Chào mừng đến với Mặt Trời và Hương Vị. Chúng tôi có phở, bánh mì, và gỏi cuốn. Bạn muốn gọi món gì?',
        },
        {
          'title': 'Buy something at the market...',
          'subtitle': 'Mua giày với giá 500.000 đồng!',
        },
        {
          'title': 'Jump into that business meeting...',
          'subtitle':
              'Để bắt đầu, chúng ta sẽ phân tích xu hướng thị trường hiện tại.',
        },
      ],
    };

    String? languageLearning =
        Provider.of<LanguageSelectionModel>(context, listen: false)
            .learningLanguage;

    List<Map<String, String>>? promptsInSelectedLanguage =
        prompts[languageLearning];

    return Scaffold(
      appBar: AppBar(
        title: null,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, size: 30),
          onPressed: () {
            Navigator.pop(context); // Updated to navigate back a page
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 60.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    constraints: const BoxConstraints(maxWidth: 350),
                    child: Text(
                      "What would you like to talk about?",
                      style: Theme.of(context).textTheme.displayLarge,
                    ),
                  ),
                  const SizedBox(height: 30),
                  Column(
                    children: promptsInSelectedLanguage!.map((prompt) {
                      bool isSelected = _selectedPromptTitle == prompt['title'];
                      return PromptTile(
                        titleText: prompt['title']!,
                        subtitleText: prompt['subtitle']!,
                        isSelected: isSelected,
                        onTap: () {
                          setState(() {
                            if (_selectedPromptTitle == prompt['title']) {
                              _selectedPromptTitle =
                                  null; // Deselect if the same tile is tapped again
                            } else {
                              _selectedPromptTitle =
                                  prompt['title']; // Select the new tile
                            }
                          });
                        },
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            Center(
              child: SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 30.0, bottom: 50, left: 20.0, right: 20.0),
                  child: Button(
                    text: 'Start Chatting',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ChatUI(promptTitle: _selectedPromptTitle == null ? null : promptsInSelectedLanguage.firstWhere((prompt) =>
                              prompt['title'] == _selectedPromptTitle)['subtitle']),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
