class LinearScale {
    private float slope;
    private float startX;

    LinearScale (float minX, float minY, float maxX, float maxY) {
        slope = (maxY - minY) / (maxX - minX);
        startX = minY - slope * minX;
    }

    float scale(float input) {
        return input * slope + startX;
    }

    float invert(float input) {
        return (input - startX) / slope;
    }
};


void dottedLine(PVector startPos, PVector endPos) {
    PVector currentPos = new PVector(startPos.x, startPos.y);
    
    float startX = currentPos.x;
    float endX = endPos.x;

    float startY = currentPos.y;
    float endY = endPos.y;

    LinearScale lineScale = new LinearScale(startX, startY, endX, endY);
    
    float curY;
    for (float curX = startX; curX < endX; curX += 2) {
        curY = lineScale.scale(curX);
        point(curX, curY);
    }
}