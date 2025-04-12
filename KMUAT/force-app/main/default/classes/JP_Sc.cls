/**
 * スケジュール
 */

global class JP_Sc {

    // 3か月前の価格表を無効化
    public static void disablePriceBook2(){

        List<PriceBook2> pbList = new List<PriceBook2>();
        FeedItem feed = new FeedItem(parentId = '0F91I000000doo5', body = '#価格表無効化');

        // 3ヶ月前の年月を取得
        String kakakuNengetsu = 'JP ' + datetime.now().addMonths(-3).format('yyyy/MM');

        pbList = [SELECT Id, Name, CURRENCYISOCODE, ISACTIVE, DESCRIPTION
                  FROM   PriceBook2
                  WHERE  Name =: kakakuNengetsu 
                         AND ISACTIVE = true];

        if(pbList.size()>0){

            for(PriceBook2 wkPb : pbList){
                wkPb.ISACTIVE = false;
            }

            update pbList;

        }

        // Chatter投稿用
        feed.body += '\n' + '対象:' + kakakuNengetsu;
        feed.body += '\n' + '件数:' + pbList.size();
        feed.body += '\n' + 'https://alliedtelesis.lightning.force.com/lightning/o/Pricebook2/list?filterName=Recent';

        insert feed;
    }

}