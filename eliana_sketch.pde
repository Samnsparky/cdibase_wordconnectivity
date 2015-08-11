import java.util.Collections;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

VisualizationChromeView chrome;
WordListView wordListView;
WordData model;


void setup() {
    loadSemiconstants();

    size(1000, 600);
    frameRate(30);

    model = loadWordData();
    chrome = createDefaultVisualizationChromeView();
    wordListView = new WordListView(
        new PVector(LEFT_MENU_WIDTH + HORIZ_PADDING, TOP_PADDING + 48),
        model,
        DEFAULT_WORD_CATEGORY
    );
}


void draw() {
    background(BACKGROUND_COLOR);

    chrome.draw();
    wordListView.draw();
}
