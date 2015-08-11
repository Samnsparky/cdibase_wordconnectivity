class WordListView implements GraphicEntity {
    private final List<WordCounts> leftWords;
    private final List<WordCounts> rightWords;
    private final PVector position;

    WordListView(PVector newPosition, WordData newWordData,
        String newCategoryName) {

        position = newPosition;
        leftWords = newWordData.getGroup1ForCategory(newCategoryName);
        rightWords = newWordData.getGroup2ForCategory(newCategoryName);
    }

    void update(float relativeMouseX, float relativeMouseY) {}

    void draw() {
        pushMatrix();
        pushStyle();

        translate(position.x, position.y);
        int y = 16;
        fill(BODY_TEXT_COLOR);
        textFont(BODY_TEXT);
        textAlign(RIGHT, BOTTOM);
        for (WordCounts count : leftWords) {
            text(count.getWord(), BODY_SECTION_WIDTH, y);
            y += 16;
        }

        popStyle();
        popMatrix();
    }

};
