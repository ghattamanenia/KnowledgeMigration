/*******************
Description: This cord is an error message class.
Developer: Hitachi Solutions, Ltd.
Date Created: 11/22/2010
Date Modified: 6/7/2011
*****************/
/**
 * エラーメッセージクラス
 */
public class ATFE_Exception extends Exception{

    // エラーメッセージの一覧定義
    
    // 見積作成機能のエラーメッセージ
    public string MSG_NoQuoteStatusChange   = '見積作成機能でErrorが発生しました。管理者へ連絡して下さい。詳細：見積データフローにて、接続エラー、または、連携対象の商談が削除された可能性があります。';

    public string MSG_Error_QuoteIFFlow     = '見積作成機能でErrorが発生しました。管理者へ連絡して下さい。詳細：見積データフローにて、見積作成依頼オブジェクトのデータが更新されませんでした。';

    public string MSG_Error_TotalTimeoutMSG  = '見積作成機能でErrorが発生しました。詳細：見積作成処理にてタイムアウトが発生しました。時間をおいて再実行するか、管理者へ問い合わせてください。';
    

    // 価格表選択機能のエラーメッセージ
    public string MSG_Error_Prb_ProfileName = 'Your Profile can\'t use this function. Please use it by each Area\'s profile user.';

    public string MSG_No_PricebookExistEn   = 'No usable pricebooks exists. Please Contact Admin to add Pricebooks.';

    public string MSG_SelectDistriError     = '選択された代理店のデータに価格表コードがありません。管理者へ連絡してください。';

    public string MSG_NoPricebooksExist     = '該当する価格表が1件もありません。管理者へ連絡してください。';

    public string MSG_SelectTooMuchItems    = '商談に紐ついている商品が多すぎます。管理者へ連絡してください。';

    public string MSG_FailtoCreateQuoteIFRecord = '見積作成機能でErrorが発生しました。管理者へ連絡して下さい。詳細：見積作成依頼オブジェクトのレコード作成に失敗しました。';

}