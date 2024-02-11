# This is the ugly way to create a dotfile when there are no
# supported module options
{ pkgs, ... }:
{
   home.file.".config/rofi/config.rasi".text = ''
	@theme "/dev/null"
	* {
	    selected-normal-foreground:  rgba ( 255, 255, 255, 100 % );
	    foreground:                  rgba ( 255, 255, 255, 100 % );
	    normal-foreground:           @foreground;
	    alternate-normal-background: transparent;
	    red:                         rgba ( 220, 50, 47, 100 % );
	    selected-urgent-foreground:  rgba ( 255, 195, 156, 100 % );
	    blue:                        rgba ( 38, 139, 210, 100 % );
	    urgent-foreground:           rgba ( 243, 132, 61, 100 % );
	    alternate-urgent-background: transparent;
	    active-foreground:           rgba ( 38, 139, 210, 100 % );
	    lightbg:                     rgba ( 238, 232, 213, 100 % );
	    selected-active-foreground:  rgba ( 32, 81, 113, 100 % );
	    alternate-active-background: transparent;
	    background:                  transparent;
	    bordercolor:                 rgba ( 57, 57, 57, 100 % );
	    alternate-normal-foreground: @foreground;
	    normal-background:           transparent;
	    lightfg:                     rgba ( 88, 104, 117, 100 % );
	    selected-normal-background:  rgba ( 38, 139, 210, 100 % );
	    border-color:                @foreground;
	    spacing:                     2;
	    separatorcolor:              rgba ( 38, 139, 210, 100 % );
	    urgent-background:           transparent;
	    selected-urgent-background:  rgba ( 38, 139, 210, 100 % );
	    alternate-urgent-foreground: @urgent-foreground;
	    background-color:            rgba ( 0, 0, 0, 0 % );
	    alternate-active-foreground: @active-foreground;
	    active-background:           rgba ( 10, 0, 71, 100 % );
	    selected-active-background:  rgba ( 38, 139, 210, 100 % );
	}
	window {
	    background-color: rgba ( 57, 57, 57, 80 % );
	    border:           1;
	    padding:          5;
	}
	mainbox {
	    border:  0;
	    padding: 0;
	}
	message {
	    border:       1px dash 0px 0px ;
	    border-color: @separatorcolor;
	    padding:      1px ;
	}
	textbox {
	    text-color: @foreground;
	}
	listview {
	    fixed-height: 0;
	    border:       2px dash 0px 0px ;
	    border-color: @separatorcolor;
	    spacing:      2px ;
	    scrollbar:    true;
	    padding:      2px 0px 0px ;
	}
	element {
	    border:  0;
	    padding: 1px ;
	}
	element-text {
	    background-color: inherit;
	    text-color:       inherit;
	}
	element.normal.normal {
	    background-color: @normal-background;
	    text-color:       @normal-foreground;
	}
	element.normal.urgent {
	    background-color: @urgent-background;
	    text-color:       @urgent-foreground;
	}
	element.normal.active {
	    background-color: @active-background;
	    text-color:       @active-foreground;
	}
	element.selected.normal {
	    background-color: @selected-normal-background;
	    text-color:       @selected-normal-foreground;
	}
	element.selected.urgent {
	    background-color: @selected-urgent-background;
	    text-color:       @selected-urgent-foreground;
	}
	element.selected.active {
	    background-color: @selected-active-background;
	    text-color:       @selected-active-foreground;
	}
	element.alternate.normal {
	    background-color: @alternate-normal-background;
	    text-color:       @alternate-normal-foreground;
	}
	element.alternate.urgent {
	    background-color: @alternate-urgent-background;
	    text-color:       @alternate-urgent-foreground;
	}
	element.alternate.active {
	    background-color: @alternate-active-background;
	    text-color:       @alternate-active-foreground;
	}
	scrollbar {
	    width:        4px ;
	    border:       0;
	    handle-width: 8px ;
	    padding:      0;
	}
	mode-switcher {
	    border:       2px dash 0px 0px ;
	    border-color: @separatorcolor;
	}
	button.selected {
	    background-color: @selected-normal-background;
	    text-color:       @selected-normal-foreground;
	}
	button {
	    background-color: @background;
	    text-color:       @foreground;
	}
	inputbar {
	    spacing:    0;
	    text-color: @normal-foreground;
	    padding:    1px ;
	}
	case-indicator {
	    spacing:    0;
	    text-color: @normal-foreground;
	}
	entry {
	    spacing:    0;
	    text-color: @normal-foreground;
	}
	prompt {
	    spacing:    0;
	    text-color: @normal-foreground;
	}
	inputbar {
	    children:   [ prompt,textbox-prompt-colon,entry,case-indicator ];
	}
	textbox-prompt-colon {
	    expand:     false;
	    str:        ":";
	    margin:     0px 0.3em 0em 0em ;
	    text-color: @normal-foreground;
	}
  '';
}
