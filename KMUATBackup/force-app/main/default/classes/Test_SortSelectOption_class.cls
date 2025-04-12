@isTest
private class Test_SortSelectOption_class {

    static testMethod void validate_SortSelectOption() 
        {
             List<SelectOption> AllSelectOptions = new List<SelectOption>();
             
              for(integer i= 0; i< 10 ; i++) 
              {
                SelectOption option = new SelectOption('A'+i,'A'+i );
                allSelectOptions.add(option);
              }
              
              allSelectOptions = SortSelectOptions.selectOptionSortByLabel(allSelectOptions);
              allSelectOptions = SortSelectOptions.selectOptionSortByValue(allSelectOptions);
        }

}