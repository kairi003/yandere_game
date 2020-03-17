; =============================================================================
; [タイトルメインファイル]
*title_main
[cm][clearstack]
[deletef var="tf"]
; =============================================================================





; スプラッシュスクリーン
@call storage="title/splash_screen.ks"





; タイトル画面
@call storage="title/title.ks"





; メニュー画面
@jump storage="title/menu-main.ks" target="menu-main" cond="sf.system.event_game == false"
*return_menu_main





@jump storage="main.ks" target="return_title"
