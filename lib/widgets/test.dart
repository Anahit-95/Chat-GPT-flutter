void main() {
  String questionString =
      "1. Which year did World War II start in Europe? \nA) 1935 | false#  \nB) 1939 | true#\nC) 1945 | false# \nD) 1914 | false% \n\n2. Who was the first president of the United States? \nA) George Washington | true# \nB) John F. Kennedy | false# \nC) Thomas Jefferson | false# \nD) Abraham Lincoln | false% \n\n3. What was the cause of the French Revolution? \nA) Economic Inequality | true# \nB) Political Stability | false# \nC) Monarchy supported by the people | false# \nD) Expansion of the French Empire | false% \n\n4. What happened on November 9th, 1989, in Germany? \nA) The Berlin Wall Fell | true# \nB) Germany World Cup Victory | false# \nC) National holiday declared | false# \nD) The Munich Agreement was signed | false% \n\n5. Who was the first female monarch of England? \nA) Elizabeth II | false# \nB) Mary I | false# \nC) Victoria | false# \nD) Mary II | true% \n\n6. What was the result of the Spanish-American War? \nA) Spain won | false# \nB) The United States annexed Puerto Rico | true# \nC) The Philippines became a French territory | false# \nD) The United States ceded Guam to Spain | false% \n\n7. What is the Magna Carta? \nA) A document limiting the power of the English monarchy | true# \nB) A treaty to end World War II | false# \nC) A charter for early Christian churches | false# \nD) An agreement between Napoleon and the Pope | false% \n\n8. Who painted the Mona Lisa? \nA) Vincent Van Gogh | false# \nB) Pablo Picasso | false# \nC) Leonardo da Vinci | true# \nD) Michelangelo | false% \n\n9. What is the significance of the Battle of Hastings? \nA) The Norman Conquest of England | true# \nB) The capture of Jerusalem by Crusaders | false# \nC) The end of the American Revolution | false# \nD) The establishment of the Spanish Inquisition | false% \n\n10. Who was the first emperor of Rome? \nA) Julius Caesar | false# \nB) Augustus | true# \nC) Hadrian | false# \nD) Nero | false%";

  String questionString1 =
      "1. When did World War II begin?\na) 1939|true# b) 1940|false# c) 1941|false# d) 1942|false%\n2. Who discovered America?\na) Christopher Columbus|false# b) Amerigo Vespucci|false# c) Leif Erikson|true# d) John Cabot|false%\n3. Who wrote the Communist Manifesto?\na) Vladimir Lenin|false# b) Joseph Stalin|false# c) Karl Marx|true# d) Mao Zedong|false%\n4. What was the first capital of the United States?\na) New York City|true# b) Washington D.C.|false# c) Philadelphia|false# d) Boston|false%\n5. What year did the Berlin Wall fall?\na) 1987|false# b) 1989|true# c) 1991|false# d) 1992|false%\n6. Who was the first President of the United States?\na) Thomas Jefferson|false# b) John Adams|false# c) George Washington|true# d) James Madison|false%\n7. Which country invented paper?\na) China|true# b) Japan|false# c) India|false# d) Egypt|false%\n8. Who painted the Mona Lisa?\na) Michelangelo|false# b) Leonardo da Vinci|true# c) Donatello|false# d) Raphael|false%\n9. What is the oldest known civilization?\na) Egypt|false# b) Mesopotamia|true# c) Greece|false# d) Rome|false%\n10. Who wrote Romeo and Juliet?\na) William Shakespeare|true# b) Charles Dickens|false# c) Jane Austen|false# d) Mark Twain|false%";

  String questionsLit =
      "1. What is the name of the narrator in \"The Catcher in the Rye\"? \nHolden Caulfield|true# Madison Caulfield|false# Pat Caulfield|false# Molly Caulfield|false%\n2. Which Shakespeare play features characters named Romeo and Juliet?\nRomeo and Juliet|false# Hamlet|false# King Lear|false# Macbeth|true%\n3. Who wrote the Harry Potter series of books?\nJ.K. Rowling|true# Stephenie Meyer|false# Suzanne Collins|false# John Green|false%\n4. In \"To Kill a Mockingbird\", what is the name of Scout's father?\nAtticus Finch|true# Bob Ewell|false# Boo Radley|false# Jem Finch|false%\n5. Where is the setting of F. Scott Fitzgerald's novel \"The Great Gatsby\"?\nLong Island|true# Paris|false# London|false# Los Angeles|false%\n6. Who is the author of \"Pride and Prejudice\"?\nJane Austen|true# Charlotte Bronte|false# Emily Bronte|false# Louisa May Alcott|false%\n7. What is the name of the main character in George Orwell's \"1984\"?\nWinston Smith|true# Holden Caulfield|false# Jay Gatsby|false# Elizabeth Bennet|false%\n8. Who wrote \"The Picture of Dorian Gray\"?\nOscar Wilde|true# Virginia Woolf|false# Ernest Hemingway|false# Mark Twain|false%\n9. What is the name of the protagonist in \"The Adventures of Huckleberry Finn\"?\nHuckleberry Finn|true# Tom Sawyer|false# Jim|false# Becky Thatcher|false%\n10. What is the name of the dystopian society in \"The Hunger Games\" series?\nPanem|true# Solaris|false# Omelas|false# Gilead|false%";
  String questionsLit1 =
      "1. Who wrote the novel \"Pride and Prejudice\"?: Jane Austen|true# Charlotte Bronte|false# Louisa May Alcott|false# Emily Bronte|false%\n2. In what year was \"To Kill a Mockingbird\" published?: 1960|true# 1950|false# 1970|false# 1980|false%\n3. Who is the protagonist in \"The Great Gatsby\"?: Jay Gatsby|true# Nick Carraway|false# Daisy Buchanan|false# Tom Buchanan|false%\n4. Which Shakespeare play features a character named Ophelia?: Hamlet|true# Romeo and Juliet|false# King Lear|false# Macbeth|false%\n5. What is the title of John Steinbeck's novel about two migrant workers during the Great Depression?: Of Mice and Men|true# The Grapes of Wrath|false# East of Eden|false# Cannery Row|false%\n6. Who wrote \"War and Peace\"?: Leo Tolstoy|true# Fyodor Dostoevsky|false# Anton Chekhov|false# Vladimir Nabokov|false%\n7. What novel features the character Holden Caulfield?: The Catcher in the Rye|true# Brave New World|false# 1984|false# Lord of the Flies|false%\n8. In J.K. Rowling's Harry Potter series, what is the name of the school the protagonist attends?: Hogwarts School of Witchcraft and Wizardry|true# Durmstrang Institute|false# Beauxbatons Academy of Magic|false# Ilvermorny School of Witchcraft and Wizardry|false%\n9. Who wrote \"The Hobbit\"?: J.R.R. Tolkien|true# C.S. Lewis|false# Roald Dahl|false# George Orwell|false%\n10. What is the title of F. Scott Fitzgerald's debut novel?: This Side of Paradise|true# Tender Is the Night|false# The Beautiful and Damned|false# The Last Tycoon|false%";
  String questionFlutter =
      "1. What is Flutter?\na) A programming language|false# b) A mobile development framework|true# c) A new social media platform|false# d) A hardware device|false%\n2. What is 'hot reload' in Flutter?\na) A feature that enables developers to see their changes in real-time|true# b) A new game in Flutter|false# c) A tool for debugging|false# d) A feature that lets you share your app with others|false%\n3. Is Flutter suitable for building large-scale apps?\na) Yes, it is optimized for building large-scale apps|true# b) No, it is only suitable for small apps|false# c) It depends on the project requirements|false# d) Flutter is not a suitable framework for app development|false%\n4. Which programming language is used to build Flutter apps?\na) Java|false# b) C++|false# c) Dart|true# d) JavaScript|false%\n5. Does Flutter support both iOS and Android platforms?\na) No, it only supports one platform|false# b) Yes, it supports both iOS and Android platforms|true# c) It depends on the version of Flutter|false# d) Flutter is not compatible with any platform|false%\n6. Which IDEs are recommended for Flutter app development?\na) Visual Studio Code and Android Studio|true# b) Eclipse and NetBeans|false# c) Visual Studio and Xcode|false# d) IntelliJ IDEA and PyCharm|false%\n7. What is a stateful widget in Flutter?\na) A widget that can have its state changed during runtime|true# b) A widget that cannot have its state changed during runtime|false# c) A widget that is stateless|false# d) A widget that is not used in Flutter|false%\n8. Can you use Flutter for web development?\na) No, Flutter is only for mobile app development|false# b) Yes, Flutter can be used for web development|true# c) It depends on the browser|false# d) Flutter is not suitable for web development|false%\n9. What is a 'widget' in Flutter?\na) A visual component that represents a part of your app's UI|true# b) A programming language|false# c) A design tool|false# d) An external library used in Flutter|false%\n10. What are 'layouts' in Flutter?\na) A way of organizing UI elements in a particular way|true# b) A programming concept|false# c) A tool for debugging|false# d) An external library used in Flutter|false%\n\n'What is Flutter?: A programming language|false# A mobile development framework|true# A new social media platform|false# A hardware device|false%\nWhat is 'hot reload' in Flutter?: A feature that enables developers to see their changes in real-time|true# A new game in Flutter|false# A tool for debugging|false# A feature that lets you share your app with others|false%\nIs Flutter suitable for building large-scale apps?: Yes, it is optimized for building large-scale apps|true# No, it is only suitable for small apps|false# It depends on the project requirements|false# Flutter is not a suitable framework for app development|false%\nWhich programming language is used to build Flutter apps?: Java|false# C++|false# Dart|true# JavaScript|false%\nDoes Flutter support both iOS and Android platforms?: No, it only supports one platform|false# Yes, it supports both iOS and Android platforms|true# It depends on the version of Flutter|false# Flutter is not compatible with any platform|false%\nWhich IDEs are recommended for Flutter app development?: Visual Studio Code and Android Studio|true# Eclipse and NetBeans|false# Visual Studio and Xcode|false# IntelliJ IDEA and PyCharm|false%\nWhat is a stateful widget in Flutter?: A widget that can have its state changed during runtime|true# A widget that cannot have its state changed during runtime|false# A widget that is stateless|false# A widget that is not used in Flutter|false%\nCan you use Flutter for web development?: No, Flutter is only for mobile app development|false# Yes, Flutter can be used for web development|true# It depends on the browser|false# Flutter is not suitable for web development|false%\nWhat is a 'widget' in Flutter?: A visual component that represents a part of your app's UI|true# A programming language|false# A design tool|false# An external library used in Flutter|false%\nWhat are 'layouts' in Flutter?: A way of organizing UI elements in a particular way|true# A programming concept|false# A tool for debugging|false# An external library used in Flutter|false% '";
  String questionFlutter1 =
      "1. What is Flutter? \nA. A software development kit for mobile app development. |true,# \nB. A video conferencing application. |false,# \nC. A game development engine. |false,# \nD. A social media platform. |false,#\n\n2. Which language is used in Flutter app development? \nA. Java |false,# \nB. Swift |false,# \nC. Dart |true,# \nD. Python |false,#\n\n3. What is the primary advantage of Flutter? \nA. Cross-platform development |true,# \nB. Advanced graphics rendering |false,# \nC. Enhanced battery life |false,# \nD. Professional networking platform |false,#\n\n4. Which operating systems does Flutter support? \nA. Windows |false,# \nB. Linux |false,# \nC. iOS |true,# \nD. All of the above |false,#\n\n5. What is Dart? \nA. A type of bird |false,# \nB. A computer processor |false,# \nC. A programming language |true,# \nD. A musical instrument |false,#\n\n6. Which company developed Flutter? \nA. Microsoft |false,# \nB. Google |true,# \nC. Amazon |false,# \nD. Apple |false,#\n\n7. What is hot reload in Flutter? \nA. A feature for reloading the engine of a car |false,# \nB. A feature for quickly seeing changes in a Flutter app |true,# \nC. A feature for cleaning up code in a Flutter app |false,# \nD. A feature for synchronizing data across different devices |false,#\n\n8. What is a widget in Flutter? \nA. A type of plant |false,# \nB. A software tool for measuring code complexity |false,# \nC. A graphical user interface element |true,# \nD. A type of virus |false,#\n\n9. Can Flutter be used for web development? \nA. No |false,# \nB. Yes, but only for mobile sites |false,# \nC. Yes, using third-party packages |false,# \nD. Yes, natively |true,#\n\n10. Which version of Flutter was released in 2021? \nA. 1.0 |false,# \nB. 2.0 |false,# \nC. 3.0 |false,# \nD. 2.2 |true,#";

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
        List<String> answerStrings = questionAndAnswers[1].split('#');
//         print(answerStrings);

        for (String answerStr in answerStrings) {
          List<String> answerAndStatus = answerStr.split('|');
//           print(answerAndStatus);

          String answerText;
          if (answerAndStatus[0].contains(')')) {
            answerText = answerAndStatus[0].split(')')[1].trim();
          } else {
            answerText = answerAndStatus[0].trim();
          }

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

  List<QuestionItem> questions = parseQuestionString(questionString);
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
