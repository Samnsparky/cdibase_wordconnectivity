class VisualizationChromeView implements GraphicEntity {

    private final String selectedWordCategoryName;
    private final String selectedSplitAttribute;
    private final String selectedStudy;
    private final String leftGroupName;
    private final String rightGroupName;
    private final float effectiveWidth;

    VisualizationChromeView(String newSelectedWordCategoryName,
        String newSelectedSplitAttribute, String newSelectedStudy,
        String newLeftGroupName, String newRightGroupName) {

        selectedWordCategoryName = newSelectedWordCategoryName;
        selectedSplitAttribute = newSelectedSplitAttribute;
        selectedStudy = newSelectedStudy;
        leftGroupName = newLeftGroupName;
        rightGroupName = newRightGroupName;

        float newEffectiveWidth = width - HORIZ_PADDING * 2;
        newEffectiveWidth -= LEFT_MENU_WIDTH;
        newEffectiveWidth -= RIGHT_DISPLAY_PADDING;
        effectiveWidth = newEffectiveWidth;
    }

    void update(float relativeMouseX, float relativeMouseY) {

    }

    void draw() {
        drawHeader();
    }

    private void drawHeader() {
        pushMatrix();
        pushStyle();

        drawTopHeader();
        drawSubheader();

        popStyle();
        popMatrix();
    }

    private void drawTopHeader() {
        pushMatrix();
        pushStyle();

        translate(
            LEFT_MENU_WIDTH + HORIZ_PADDING,
            TOP_PADDING
        );

        textFont(HEADER_TEXT);
        textAlign(LEFT, TOP);
        fill(HEADER_COLOR);
        text(createTitleText(), 0, 0);

        translate(0, 29);
        noFill();
        stroke(HEADER_COLOR);
        line(0, 0, effectiveWidth, 0);

        popStyle();
        popMatrix();
    }

    private void drawSubheader() {
        pushMatrix();
        pushStyle();

        float targetX = LEFT_MENU_WIDTH + HORIZ_PADDING;
        float targetY = TOP_PADDING;
        targetY += 29; // For top level header
        targetY += 17; // For subheader text height

        textFont(BODY_TEXT);
        textAlign(LEFT, BOTTOM);
        fill(BODY_TEXT_COLOR);
        noStroke();

        // Left header
        translate(targetX, targetY);

        noStroke();
        fill(BODY_TEXT_COLOR);
        text(leftGroupName, 0, -1);
        
        noFill();
        stroke(BODY_TEXT_COLOR);
        dottedLine(new PVector(0, 0), new PVector(BODY_SECTION_WIDTH, 0));

        // Right header
        translate(effectiveWidth - BODY_SECTION_WIDTH, 0);

        noStroke();
        fill(BODY_TEXT_COLOR);
        text(rightGroupName, 0, -1);
        
        noFill();
        stroke(BODY_TEXT_COLOR);
        dottedLine(new PVector(0, 0), new PVector(BODY_SECTION_WIDTH, 0));

        popStyle();
        popMatrix();
    }

    private String createTitleText() {
        String retTitle = selectedWordCategoryName;
        retTitle += " for ";
        retTitle += selectedStudy;
        retTitle += " split on ";
        retTitle += selectedSplitAttribute;
        retTitle += ".";

        return retTitle;
    }

};


VisualizationChromeView createDefaultVisualizationChromeView() {
    return new VisualizationChromeView(
        "All words",
        "percentile",
        "all studies",
        "< 20 percentile",
        "> 80 percentile"
    );
}
