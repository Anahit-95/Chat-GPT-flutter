void main() {
  // String questionString =
  //     "1. When did Christopher Columbus land in America?: 1492 | true ,# 1402 | false ,# 1620 | false ,# 1787 | false %\n2. Who gave the \"I Have a Dream\" speech during the Civil Rights Movement?: Martin Luther King Jr. | true ,# Malcolm X | false ,# Rosa Parks | false ,# Jesse Jackson | false %\n3. Which dynasty ruled China during the construction of the Great Wall?: Qin dynasty | true ,# Ming dynasty | false ,# Tang dynasty | false ,# Han dynasty | false %\n4. In which year did the French Revolution begin?: 1789 | true ,# 1899 | false ,# 1989 | false ,# 1689 | false %\n5. Who was the first female pharaoh of Egypt?: Hatshepsut | true ,# Cleopatra | false ,# Nefertiti | false ,# Thutmose III | false %\n6. What event is considered the start of World War II?: Invasion of Poland | true ,# Atomic bombings of Hiroshima and Nagasaki | false ,# D-Day | false ,# Battle of Stalingrad | false %\n7. Who was the first emperor of Rome?: Augustus | true ,# Julius Caesar | false ,# Nero | false ,# Constantine | false %\n8. Which country was the first to circumnavigate the globe?: Spain | true ,# Portugal | false ,# England | false ,# France | false %\n9. When was the Berlin Wall built?: 1961 | true ,# 1945 | false ,# 1991 | false ,# 1956 | false %\n10. Who discovered gravity?: Isaac Newton | true ,# Galileo Galilei | false ,# Albert Einstein | false ,# Johannes Kepler | false %";

  // String questionString1 =
  //     "1. When did World War I begin?:  1914 | true ,# 1939 | false ,# 1945 | false ,# 1921 | false %\n2. In what year was the Magna Carta signed?: 1215 | true ,# 1066 | false ,# 1492 | false ,# 1812 | false %\n3. What battle marked the end of the Napoleonic Wars?: Waterloo | true ,# Stalingrad | false ,# Gettysburg | false ,# Iwo Jima | false %\n4. Who was the last pharaoh of ancient Egypt?: Cleopatra | true ,# Nefertiti | false ,# Tutankhamun | false ,# Ramesses II | false %\n5. What was the name of the Chinese philosopher who wrote The Art of War?: Sun Tzu | true ,# Confucius | false ,# Laozi | false ,# Mencius | false %\n6. Which ancient civilization built Machu Picchu?: Incas | true ,# Aztecs | false ,# Mayans | false ,# Egyptians | false %\n7. What was the main cause of the American Civil War?: slavery | true ,# states’ rights | false ,# taxation | false ,# religion | false %\n8. Who was the first emperor of Rome?: Augustus | true ,# Julius Caesar | false ,# Nero | false ,# Trajan | false %\n9. When was the Berlin Wall torn down?: 1989 | true ,# 1975 | false ,# 1964 | false ,# 1991 | false %\n10. Who was the first explorer to circumnavigate the globe?: Ferdinand Magellan | true ,# Christopher Columbus | false ,# Vasco da Gama | false ,# James Cook | false %";

  // String questionsLit =
  //     "1. Who is the author of \"To Kill a Mockingbird\"?: Harper Lee | true ,# William Shakespeare | false ,# Jane Austen | false ,# Ernest Hemingway | false %\n2. In \"The Great Gatsby\", what is the name of the narrator?: Nick Carraway | true ,# Daisy Buchanan | false ,# Jay Gatsby | false ,# Tom Buchanan | false %\n3. What was the profession of the main character in \"The Catcher in the Rye\"?: Student | true ,# Doctor | false ,# Lawyer | false ,# Writer | false %\n4. Who wrote \"Pride and Prejudice\"?: Jane Austen | true ,# George Orwell | false ,# Charles Dickens | false ,# Leo Tolstoy | false %\n5. In \"The Lord of the Rings\", what is the name of the wizard?: Gandalf | true ,# Dumbledore | false ,# Merlin | false ,# Saruman | false %\n6. What is the name of the monster in Mary Shelley's \"Frankenstein\"?: Frankenstein's Monster | true ,# Dracula | false ,# The Wolfman | false ,# The Mummy | false %\n7. Who wrote \"The Grapes of Wrath\"?: John Steinbeck | true ,# F. Scott Fitzgerald | false ,# Ernest Hemingway | false ,# Jack Kerouac | false %\n8. In \"Animal Farm\", which animal represents the working class?: Horse | true ,# Pig | false ,# Goat | false ,# Cow | false %\n9. Who wrote \"Brave New World\"?: Aldous Huxley | true ,# George Orwell | false ,# Ray Bradbury | false ,# Isaac Asimov | false %\n10. What is the name of the title character in \"Alice's Adventures in Wonderland\"?: Alice | true ,# Dorothy | false ,# Wendy | false ,# Belle | false %";

  // String questionsLit1 =
  //     "1. Who wrote \"Pride and Prejudice\"?: Jane Austen | true ,# Charlotte Bronte | false ,# Virginia Woolf | false ,# Emily Bronte | false %\n2. What is the title of F. Scott Fitzgerald's most famous novel?: The Great Gatsby | true ,# To Kill a Mockingbird | false ,# Animal Farm | false ,# Lord of the Flies | false %\n3. Who is the author of the \"Harry Potter\" series?: J.K. Rowling | true ,# Stephenie Meyer | false ,# Suzanne Collins | false ,# Veronica Roth | false %\n4. What is the title of Ernest Hemingway's novel that tells the story of an old fisherman's struggle to catch a giant marlin?: The Old Man and the Sea | true ,# A Farewell to Arms | false ,# For Whom the Bell Tolls | false ,# The Sun Also Rises | false %\n5. Who wrote \"The Catcher in the Rye\"?: J.D. Salinger | true ,# Harper Lee | false ,# Truman Capote | false ,# Sylvia Plath | false %\n6. What is the title of the first book in J.R.R. Tolkien's \"Lord of the Rings\" series?: The Fellowship of the Ring | true ,# The Two Towers | false ,# The Return of the King | false ,# The Hobbit | false %\n7. Who is the author of \"The Chronicles of Narnia\" series?: C.S. Lewis | true ,# Lewis Carroll | false ,# J.M. Barrie | false ,# J.K. Rowling | false %\n8. What is the title of Margaret Atwood's dystopian novel about a future society? : The Handmaid's Tale | true ,# 1984 | false ,# Fahrenheit 451 | false ,# Brave New World | false %\n9. Who wrote the novel \"To Kill a Mockingbird\"?: Harper Lee | true ,# John Steinbeck | false ,# Toni Morrison | false ,# Maya Angelou | false %\n10. What is the title of Khaled Hosseini's debut novel about two boys growing up in Afghanistan?: The Kite Runner | true ,# A Thousand Splendid Suns | false ,# And the Mountains Echoed | false ,# The Swallows of Kabul | false %";

  // String questionFlutter =
  //     "1. What is Flutter? : A) A mobile app SDK | true,# B) A programming language | false,# C) A web development framework | false,# D) A database management system | false%\n2. What programming language is used in Flutter? : A) Java | false,# B) Swift | false,# C) Dart | true,# D) Python | false%\n3. Which platforms does Flutter support? : A) iOS | true,# B) Android | true,# C) Windows | false,# D) Linux | false%\n4. Who created Flutter? : A) Facebook | false,# B) Google | true,# C) Apple | false,# D) Microsoft | false%\n5. What is the widget tree in Flutter? : A) A hierarchical structure of Widgets | true,# B) A database | false,# C) A programming language | false,# D) An IDE | false%\n6. What is hot reload in Flutter? : A) A debugging tool | false,# B) A widget | false,# C) A feature for quickly viewing changes in the app | true,# D) An API | false%\n7. What is a StatelessWidget in Flutter? : A) A widget that can be changed | false,# B) A widget that has a state | false,# C) A widget without a state | true,# D) A widget that is deprecated | false%\n8. What is the purpose of the pubspec.yaml file in Flutter? : A) To store app data | false,# B) To set up Firebase | false,# C) To manage app dependencies | true,# D) To create UI elements | false%\n9. What is the purpose of the Scaffold widget in Flutter? : A) To create a navigation drawer | false,# B) To create a bottom navigation bar | false,# C) To provide basic visual elements for an app | true,# D) To create animations | false%\n10. What is the difference between setState() and StatelessWidget in Flutter? : A) There is no difference | false,# B) setState() is used for stateful widgets while StatelessWidget has no state | true,# C) setState() is used for StatelessWidget while stateful widgets have no state | false,# D) setState() is a method while StatelessWidget is a type of widget | false%";

  // String questionFlutter1 =
  //     "1. What is Flutter? \nA. A software development kit for mobile app development. |true,# \nB. A video conferencing application. |false,# \nC. A game development engine. |false,# \nD. A social media platform. |false,#\n\n2. Which language is used in Flutter app development? \nA. Java |false,# \nB. Swift |false,# \nC. Dart |true,# \nD. Python |false,#\n\n3. What is the primary advantage of Flutter? \nA. Cross-platform development |true,# \nB. Advanced graphics rendering |false,# \nC. Enhanced battery life |false,# \nD. Professional networking platform |false,#\n\n4. Which operating systems does Flutter support? \nA. Windows |false,# \nB. Linux |false,# \nC. iOS |true,# \nD. All of the above |false,#\n\n5. What is Dart? \nA. A type of bird |false,# \nB. A computer processor |false,# \nC. A programming language |true,# \nD. A musical instrument |false,#\n\n6. Which company developed Flutter? \nA. Microsoft |false,# \nB. Google |true,# \nC. Amazon |false,# \nD. Apple |false,#\n\n7. What is hot reload in Flutter? \nA. A feature for reloading the engine of a car |false,# \nB. A feature for quickly seeing changes in a Flutter app |true,# \nC. A feature for cleaning up code in a Flutter app |false,# \nD. A feature for synchronizing data across different devices |false,#\n\n8. What is a widget in Flutter? \nA. A type of plant |false,# \nB. A software tool for measuring code complexity |false,# \nC. A graphical user interface element |true,# \nD. A type of virus |false,#\n\n9. Can Flutter be used for web development? \nA. No |false,# \nB. Yes, but only for mobile sites |false,# \nC. Yes, using third-party packages |false,# \nD. Yes, natively |true,#\n\n10. Which version of Flutter was released in 2021? \nA. 1.0 |false,# \nB. 2.0 |false,# \nC. 3.0 |false,# \nD. 2.2 |true,#";

  String questionFlutter2 =
      "1. What programming language does Flutter use?: Dart | true ,# Python | false ,# JavaScript | false ,# C++ | false %\n2. What is Flutter primarily used for?: Building mobile applications | true ,# Building desktop applications | false ,# Building web applications | false ,# Building database systems | false %\n3. Which company developed Flutter?: Google | true ,# Microsoft | false ,# Apple | false ,# Facebook | false %\n4. What is the framework of Flutter called?: Widgets | true ,# Components | false ,# Elements | false ,# Modules | false %\n5. What is the difference between StatelessWidget and StatefulWidget?: The former represents widgets that cannot be modified, while the latter is for widgets that can change based on user interaction | true ,# The former is used for building mobile apps, while the latter is for building desktop apps | false ,# The former is written in JavaScript, while the latter uses Dart | false ,# The former is a newer feature of Flutter, while the latter is an older one | false %\n6. What does 'hot reload' do in Flutter?: It allows developers to instantly see changes they make to their code without having to rebuild a new version of the app | true ,# It compresses the size of the app for easier deployment | false ,# It optimizes the performance of the app for faster loading times | false ,# It generates error messages for debugging purposes | false %\n7. What is the main advantage of Flutter over other cross-platform frameworks?: It provides a higher level of customization and control over the app's UI and performance | true ,# It allows developers to write code in multiple programming languages | false ,# It has better compatibility with third-party libraries and APIs | false ,# It generates code templates automatically, saving time and effort for the developer | false %\n8. What are some popular apps built with Flutter?: Alibaba, Reflectly, Hamilton Musical, Google Ads | true ,# Snapchat, Netflix, Facebook, Instagram | false ,# Spotify, Airbnb, LinkedIn, Twitter | false ,# Amazon, Uber, Dropbox, Slack | false %\n9. What is 'Flutter Doctor' and what is its purpose?: It is a command-line tool used for diagnosing and fixing issues with the Flutter installation and environment | true ,# It is a feature for testing apps on virtual devices | false ,# It is a plugin for integrating Google Analytics into Flutter apps | false ,# It is a service for hosting Flutter apps on a cloud platform | false %\n10. Can Flutter apps be developed on both Windows and macOS?: Yes | true ,# No | false ,# Only on Linux computers | false ,# Only on Chromebooks | false %";

  // String questionString2 =
  //     "1. What is the programming language used in Flutter development?: Dart | true ,# C++ | false ,# Python | false ,# Java | false %\n2. Which IDEs can be used for Flutter development?: Android Studio, Visual Studio Code | true ,# Eclipse, Xcode | false ,# Atom, Sublime Text | false ,# NetBeans, IntelliJ IDEA | false %\n3. What is the widget tree in Flutter?: A visual representation of a widget hierarchy | true ,# A list of all available widgets | false ,# A collection of widgets' styles | false ,# None of the above | false %\n4. What is a stateful widget in Flutter?: A widget that can change its state | true ,# A widget that always has the same state | false ,# A widget without a state | false ,# A widget with multiple states | false %\n5. What is hot reload in Flutter?: A feature that allows developers to instantly see the result of code changes | true ,# A debugging tool for finding errors in code | false ,# A code formatter | false ,# A feature that allows developers to run multiple devices simultaneously | false %\n6. What is a scaffold in Flutter?: A basic visual structure for a Flutter app | true ,# A framework for building animations | false ,# A package management tool | false ,# A testing framework | false %\n7. What is a stream in Flutter?: A sequence of asynchronous events | true ,# A collection of widgets | false ,# A list of function arguments | false ,# A database wrapper | false %\n8. What is the pubspec.yaml file in Flutter?: A file that lists dependencies and metadata of a Flutter project | true ,# A file that lists available widgets | false ,# A file that defines the layout of a Flutter app | false ,# A file that specifies runtime permissions | false %\n9. What is the difference between StatelessWidget and StatefulWidget in Flutter?: A StatelessWidget cannot change its state, while a StatefulWidget can | true ,# A StatefulWidget has better performance than a StatelessWidget | false ,# A StatelessWidget is more versatile than a StatefulWidget | false ,# There is no difference between the two | false %\n10. What is an InheritedWidget in Flutter?: A widget that passes data down to its child widgets | true ,# A widget that only appears on specific screen sizes | false ,# A widget that handles user input | false ,# A widget that displays images | false %";

  List<QuestionItem> parseQuestionString(String questionString) {
    List<QuestionItem> questionList = [];

    List<String> questionStrings = questionString.split('%');
//     print(questionStrings);

    for (String questionStr in questionStrings) {
//       print(questionStr);
      if (questionStr.length < 10) {
        continue;
      }
      List<String> questionAndAnswers;
      if (questionStr.split(':').length == 2) {
        questionAndAnswers = questionStr.split(':');
      } else {
        questionAndAnswers = questionStr.split('?');
      }
//       print(questionAndAnswers);

      String question = questionAndAnswers[0].split('?')[0].trim();
//       print(question);

      List<Answer> answerList = [];

      if (questionAndAnswers.length == 2) {
        List<String> answerStrings = questionAndAnswers[1].split(',#');
//         print(answerStrings);

        for (String answerStr in answerStrings) {
          List<String> answerAndStatus = answerStr.split('|');
//           print(answerAndStatus);

          String answerText = answerAndStatus[0].trim();
//           if (answerAndStatus[0].contains(')')) {
//             answerText = answerAndStatus[0].split(')')[1].trim();
//           } else {
//             answerText = answerAndStatus[0].trim();
//           }

          bool isCorrect = (answerAndStatus[1].trim().toLowerCase() == 'true');
//           print(isCorrect);

          answerList.add(Answer(answerText, isCorrect));
          answerList.shuffle();
        }
      }

      questionList.add(QuestionItem(question, answerList));
    }

    return questionList;
  }

  List<QuestionItem> questions = parseQuestionString(questionFlutter2);
//   print(questions.length);
  for (QuestionItem question in questions) {
    print(question.question + ' ?');
//     print(question.answers.length);
    for (Answer answer in question.answers) {
      print('${answer.text} - ${answer.isCorrect}');
    }
    print('');
  }
}

class QuestionItem {
  final String question;
  final List<Answer> answers;

  QuestionItem(this.question, this.answers);
}

class Answer {
  final String text;
  final bool isCorrect;

  Answer(this.text, this.isCorrect);
}
