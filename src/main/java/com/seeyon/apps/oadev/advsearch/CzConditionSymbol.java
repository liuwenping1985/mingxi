package com.seeyon.apps.oadev.advsearch;




  public enum CzConditionSymbol
  {
    equal("=", "==", "="),  notEqual("<>", "!=", "<>"),  greatThan(">", ">", ">"),  greatAndEqual(">=", ">=", ">="),  lessThan("<", "<", "<"),  lessAndEqual("<=", "<=", "<="),  like("like", "like", "��"),  not_like("not_like", "not_like", "����"),  include("include", "include", "include"), in("in","in","����"), not_in("not in","not in","������");
    
    private String key;
    private String text;
    private String showCondition;
    
    private CzConditionSymbol(String key, String text, String showCondition)
    {
      this.key = key;
      this.text = text;
      this.showCondition = showCondition;
    }
    
    public String getKey()
    {
      return this.key;
    }
    
    public String getText()
    {
      return this.text;
    }
    
    public static CzConditionSymbol getEnumByKey(String key)
    {
      for (CzConditionSymbol e : values() ) {
        if (e.getKey().equals(key)) {
          return e;
        }
      }
      return null;
    }
    
    public static CzConditionSymbol getEnumByText(String text)
    {
      for (CzConditionSymbol e : values() ) {
        if (e.getText().equals(text)) {
          return e;
        }
      }
      return null;
    }
    
    public String getShowCondition()
    {
      return this.showCondition;
    }
}
