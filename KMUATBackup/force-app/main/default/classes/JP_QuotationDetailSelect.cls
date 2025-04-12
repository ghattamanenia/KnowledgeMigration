public class JP_QuotationDetailSelect implements Comparable {
      // ALLIEDTELESIS-416 20191126 Mod
      // private set → set（行入れ替えのため） 
      public JP_QuotationDetail__c obj { get; set; }

      public boolean selected { get; set; }
      public transient String errProductCatalogCode{get; set;}
      public transient String errCode{get; set;}
      //rowNo
      public Integer rowNo { get; set; }
      public Boolean isProductError;

      public JP_QuotationDetailSelect( JP_QuotationDetail__c obj ){
         this.obj = obj;
         this.selected = false;
         this.rowNo = 0;
         this.isProductError = false;
      }
      
      // Implement the compareTo() method
      public Integer compareTo(Object compareTo) {
         JP_QuotationDetailSelect compareToQDS = (JP_QuotationDetailSelect)compareTo;
         Decimal target = this.nullToZero(this.obj.JP_Sort__c) * 1000 + this.nullToZero(this.obj.JP_DetailsNo__c);
         Decimal compare = this.nullToZero(compareToQDS.obj.JP_Sort__c) * 1000 + this.nullToZero(compareToQDS.obj.JP_DetailsNo__c);
         
         if(target == compare) return 0;
         if(target > compare) return 1;
         return -1;
      }

      /**
       * nullを0に変換します
       * @param src 値
       * @return 変換した数値
       */
      private Decimal nullToZero(Decimal src) {
         Decimal dest = 0;
         if (src != null) {
            dest = src;
         }
         return dest;
      }
}