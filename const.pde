final int BACKGROUND_COLOR = unhex("FFE6E6E6");

final int BODY_SECTION_PADDING = 100;

int BODY_SECTION_WIDTH;

PFont BODY_TEXT;

final int BODY_TEXT_COLOR = unhex("FF272822");

final String DEFAULT_WORD_CATEGORY = "Animals";

final int HEADER_COLOR = unhex("FF272822");

PFont HEADER_TEXT;

final int HORIZ_PADDING = 10;

final int LEFT_MENU_WIDTH = 200;

final int RIGHT_DISPLAY_PADDING = 150;

final int TOP_PADDING = 10;


void loadSemiconstants() {
    BODY_TEXT = loadFont("Lato-Regular-12.vlw");
    HEADER_TEXT = loadFont("GoudyBookletter1911-24.vlw");

    BODY_SECTION_WIDTH = width - LEFT_MENU_WIDTH - 2 * HORIZ_PADDING;
    BODY_SECTION_WIDTH -= RIGHT_DISPLAY_PADDING;
    BODY_SECTION_WIDTH /= 2;
    BODY_SECTION_WIDTH -= BODY_SECTION_PADDING;
}
