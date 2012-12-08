
class Interpreter {

  public  RiLexicon lex;
  public  boolean   waiting;
  public  boolean   spaceIndicator;
  private HashMap   alphabet;
  private int       pauseLength;
  private int       gapLength;
  private String    input;
  private int       counter;
  private int       spaceCounter;
  
  
  Interpreter(int p, int g) {
    
    waiting        = true;
    pauseLength    = p;
    gapLength      = g;
    input          = "";
    counter        = 0;
    spaceCounter   = 0;
    spaceIndicator = false;
    
    alphabet = new HashMap();
    alphabet.put("a","12");
    alphabet.put("b","2111");
    alphabet.put("c","2121");
    alphabet.put("d","211");
    alphabet.put("e","1");
    alphabet.put("f","1121");
    alphabet.put("g","221");
    alphabet.put("h","1111");
    alphabet.put("i","11");
    alphabet.put("j","1222");
    alphabet.put("k","212");
    alphabet.put("l","1211");
    alphabet.put("m","22");
    alphabet.put("n","21");
    alphabet.put("o","222");
    alphabet.put("p","1221");
    alphabet.put("q","2212");
    alphabet.put("r","121");
    alphabet.put("s","111");
    alphabet.put("t","2");
    alphabet.put("u","112");
    alphabet.put("v","1112");
    alphabet.put("w","122");
    alphabet.put("x","2112");
    alphabet.put("y","2122");
    alphabet.put("z","2211");
    alphabet.put("0","22222");
    alphabet.put("1","12222");
    alphabet.put("2","11222");
    alphabet.put("3","11122");
    alphabet.put("4","11112");
    alphabet.put("5","11111");
    alphabet.put("6","21111");
    alphabet.put("7","22111");
    alphabet.put("8","22211");
    alphabet.put("9","22221");
    alphabet.put(".","121212");
    alphabet.put(",","221122");
    alphabet.put("?","112211");
    alphabet.put("@","122121");
  }
  
  public void tick() {
    if(!waiting){
      if(counter < pauseLength && input.length() <= 6){
        counter++; 
        println("(" + counter + ") " + input);
      }
      else {
        waiting = true;
        spaceCounter = pauseLength + 1;
        tweet += decode(input);
        input = "";
      }
    }
    else {
      spaceIndicator = false;
      if(spaceCounter > 0 && spaceCounter < gapLength){
        spaceCounter++;
      }
      else if(spaceCounter == gapLength){
        if(tweet.length() > 0 
            && tweet.charAt(tweet.length()-1) != ' '){
          tweet += " ";
          spaceCounter = 0;
          spaceIndicator = true;
          println("INSERTING SPACE");
          if(GENIUS_MODE){
            tweet = checkSpelling(tweet);
          }
        }
      }
      
      if(GENIUS_MODE && tweet.length() >= 140) {
        postTweet();
      }
      
    }
  }
  
  public void feedInput(String peck) {
    input += peck;
    counter = 0;
    waiting = false;
  }
  
  public void reConfigure(int p, int g) {
    pauseLength = p;
    gapLength = g;
  }
  
  public String decode(String d){
    Iterator i = alphabet.keySet().iterator();
    String key;
    boolean matches;
    
    while (i.hasNext()) {
      key = (String) i.next();
      matches = d.equals(alphabet.get(key));
      if(matches == true){
        println(">>>> " + key);
        return key;
      }
    }
    
    if(d.length() > 4 && DOUBLE_CHECK){
    
      d = d.substring(0,3);
      i = alphabet.keySet().iterator();
      
      while (i.hasNext()) {
        key = (String) i.next();
        matches = d.equals(alphabet.get(key));
        if(matches == true){
          println(d + " -> " + key);
          return key;
        }
      }
    
    }
    
    println("NO MATCH");
    return "";
  }
  
  public boolean isDah() {
    if(input.charAt(input.length()-1) == '2'){
      return true;
    }
    else {
      return false;
    }
  }
  
  public String checkSpelling(String t) {
  
    String[] words = splitTokens(t, " ");
    String lastWord = words[words.length-1];
    
    if(lex.contains(lastWord) == false && lastWord.charAt(0) != '@') {
      String[] suggestions = lex.similarByLetter(lastWord);
      println(suggestions);
      
      int suglength = suggestions.length;
      
      if(suglength > 0){
        int rand = floor(random(suglength));
        println("Choosing: " + rand);
        return t.substring(0, t.length() - (lastWord.length() + 1)) + suggestions[rand] + " ";
      }
      else {
        return t;
      }
    }
    else { 
      return t; 
    }
  
  }
  
}

