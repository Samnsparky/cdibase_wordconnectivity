import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

class WordCategory {

    private final String categoryName;
    private final Set<String> categoryWords;

    WordCategory(String newCategoryName, Set<String> newCategoryWords) {
        categoryName = newCategoryName;
        categoryWords = newCategoryWords;
    }

    String getCategoryName() {
        return categoryName;
    }

    Set<String> getCategoryWords() {
        return categoryWords;
    }

};


class WordCounts implements Comparable<WordCounts> {

    private final String word;
    private final int wordSaidCount;
    private final int cdiCount;

    WordCounts(String newWord, int newWordSaidCount, int newCDICount) {

        word = newWord;
        wordSaidCount = newWordSaidCount;
        cdiCount = newCDICount;
    }

    String getWord() {
        return word;
    }

    int getSaidCount() {
        return wordSaidCount;
    }

    int getCDICount() {
        return cdiCount;
    }

    float getSaidPercent() {
        return getSaidCount() / ((float)getCDICount()) * 100;
    }

    int compareTo(WordCounts other) {
        return other.getSaidPercent() > getSaidPercent() ? -1 : 1;
    }

};


class WordCountsGroup {
    private final Map<String, WordCounts> wordCounts;

    WordCountsGroup(Map<String, WordCounts> newWordCounts) {
        wordCounts = newWordCounts;
    }

    int getSaidCount(String word) {
        return wordCounts.get(word).getSaidCount();
    }

    int getCDICount(String word) {
        return wordCounts.get(word).getCDICount();
    }

    float getSaidPercent(String word) {
        return wordCounts.get(word).getSaidPercent();
    }

    List<WordCounts> getSortedCounts() {
        List<WordCounts> counts = new ArrayList<WordCounts>(
            wordCounts.values()
        );

        Collections.sort(counts);
        return counts;
    }

}


class WordData {
    private final Map<String, WordCategory> wordCategories;
    private final WordCountsGroup group1WordCounts;
    private final WordCountsGroup group2WordCounts;

    WordData(Map<String, WordCategory> newWordCategories,
        WordCountsGroup newGroup1WordCounts,
        WordCountsGroup newGroup2WordCounts) {

        wordCategories = newWordCategories;
        group1WordCounts = newGroup1WordCounts;
        group2WordCounts = newGroup2WordCounts;
    }

    WordCountsGroup getGroup1Counts() {
        return group1WordCounts;
    }

    WordCountsGroup getGroup2Counts() {
        return group2WordCounts;
    }

    List<WordCounts> getGroup1ForCategory(String categoryName) {
        List<WordCounts> wordCounts = group1WordCounts.getSortedCounts();
        Set<String> categoryWords = getWordsForCategory(categoryName);
        return filterWords(wordCounts, categoryWords);
    }

    List<WordCounts> getGroup2ForCategory(String categoryName) {
        List<WordCounts> wordCounts = group2WordCounts.getSortedCounts();
        Set<String> categoryWords = getWordsForCategory(categoryName);
        return filterWords(wordCounts, categoryWords);
    }

    Set<String> getWordsForCategory(String categoryName) {
        return wordCategories.get(categoryName).getCategoryWords();
    }

    private List<WordCounts> filterWords(List<WordCounts> wordCounts,
        Set<String> categoryWords) {

        List<WordCounts> retList = new ArrayList<WordCounts>();
        
        for (WordCounts count : wordCounts) {
            if (categoryWords.contains(count.getWord())) {
                retList.add(count);
            }
        }

        return retList;
    }
}


class WordDataBuilder {
    private Map<String, WordCategory> wordCategories;
    private Map<String, WordCounts> group1WordCounts;
    private Map<String, WordCounts> group2WordCounts;

    WordDataBuilder() {
        wordCategories = null;
        group1WordCounts = null;
        group2WordCounts = null;
    }

    WordData build() {
        boolean ready = true;
        ready = ready && wordCategories != null;
        ready = ready && group1WordCounts != null;
        ready = ready && group2WordCounts != null;

        if (!ready) {
            throw new RuntimeException("Incomplete word data builder.");
        }

        return new WordData(
            wordCategories,
            new WordCountsGroup(group1WordCounts),
            new WordCountsGroup(group2WordCounts)
        );
    }

    void setWordCategories(String fileLoc) {
        wordCategories = new HashMap<String, WordCategory>();
        
        JSONObject rootObject = loadJSONObject("word_categories.json");
        JSONArray categoriesList = rootObject.getJSONArray("categories");
        
        JSONObject rawCategoryObject;
        JSONArray rawCategoryWordArray;
        String newCategoryName;
        String newWord;
        int numWords;
        Set<String> newWordsSet;
        WordCategory newWordCategory;
        
        int numCategories = categoriesList.size();
        for (int i = 0; i < numCategories; i++) {
            rawCategoryObject = categoriesList.getJSONObject(i);
            newCategoryName = rawCategoryObject.getString("name");
            rawCategoryWordArray = rawCategoryObject.getJSONArray("words");

            newWordsSet = new HashSet<String>();
            numWords = rawCategoryWordArray.size();
            for (int j = 0; j < numWords; j++) {
                newWord = rawCategoryWordArray.getString(j);
                newWordsSet.add(newWord);
            }

            newWordCategory = new WordCategory(
                newCategoryName,
                newWordsSet
            );
            wordCategories.put(newCategoryName, newWordCategory);
        }
    }

    void setGroup1WordCounts(String fileLoc) {
        group1WordCounts = buildWordCounts(fileLoc);
    }

    void setGroup2WordCounts(String fileLoc) {
        group2WordCounts = buildWordCounts(fileLoc);
    }

    private Map<String, WordCounts> buildWordCounts(String fileLoc) {
        Map<String, WordCounts> wordCounts = new HashMap<String, WordCounts>();

        JSONObject rootObject = loadJSONObject(fileLoc);
        JSONArray rawCountsArray = rootObject.getJSONArray("counts");
        Map<String, Integer> saidCounts = new HashMap<String, Integer>();
        Map<String, Integer> cdiCounts = new HashMap<String, Integer>();

        int wordValue;
        int count;
        int numCounts = rawCountsArray.size();
        JSONObject rawWordInfo;
        for (int i = 0; i < numCounts; i++) {
            String word;

            rawWordInfo = rawCountsArray.getJSONObject(i);
            word = rawWordInfo.getString("word");
            wordValue = rawWordInfo.getInt("value");
            count = rawWordInfo.getInt("count");

            if (!saidCounts.containsKey(word)) {
                saidCounts.put(word, 0);
            }
            if (wordValue > 0) {
                saidCounts.put(word, saidCounts.get(word) + count);
            }

            if (!cdiCounts.containsKey(word)) {
                cdiCounts.put(word, 0);
            }
            cdiCounts.put(word, cdiCounts.get(word) + count);
        }

        for (String word : cdiCounts.keySet()) {
            wordCounts.put(
                word,
                new WordCounts(word, saidCounts.get(word), cdiCounts.get(word))
            );
        }

        return wordCounts;
    }
}


WordData loadWordData() {
    WordDataBuilder builder = new WordDataBuilder();
    builder.setWordCategories("word_categories.json");
    builder.setGroup1WordCounts("word_values_low.json");
    builder.setGroup2WordCounts("word_values_high.json");
    return builder.build();
}
