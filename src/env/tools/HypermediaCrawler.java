package tools;

import cartago.*;

import java.io.BufferedWriter;
import java.io.FileWriter;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;

import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import org.jsoup.select.Elements;

/**
 An artifact crawling a hypermedia environment starting from an entry point URL (entryPoint)
 Followed the patterns for crawlers found at https://www.ra.ethz.ch/cdstore/www7/1875/com1875.htm
 and https://www.javatpoint.com/web-crawler-java

 Task 1 Step 1
*/
public class HypermediaCrawler extends Artifact {

    private String entryPoint;
    private HashSet<String> urls;
    private List<String> visitedURLs;


    public void init(String url) {
        System.out.println("HypermediaCrawler initialized");
        this.entryPoint = url;
        this.visitedURLs = new ArrayList<String>();
        this.urls = new HashSet<String>();
        urls.add(entryPoint);
    }

    /**
     * @param relationType specifies the semantics of the target link to the document of interest.
     * @param filePath where the document should be saved to for the org_agent to access
     */
    @OPERATION
    public void searchEnvironment(String relationType, OpFeedbackParam<String> filePath) {
        while (!urls.isEmpty()) {
            String url = urls.iterator().next();
            urls.remove(url);
            if (shouldVisit(url)) {
                //System.out.println("Visiting url: " + url);
                Elements content = visit(url);
                for (Element element : content) {
                    if (element.toString().contains(relationType)) {
                        Document doc = getDocument(element);
                        filePath.set(storeDocument(doc.toString()));
                        return;
                    }
                }
            }
        }
    }

    // decides whether url should be followed ("visited") by the crawler.
    public boolean shouldVisit(String url) {
        return !visitedURLs.contains(url);
    }

    private Document getDocument(Element element) {
        String documentURL = element.child(0).attr("abs:href");
        try {
            return Jsoup.connect(documentURL).get();
        } catch (IOException e) {
            e.printStackTrace();
            return new Document("");
        }
    }

    private Elements visit(String url) {
        visitedURLs.add(url);
        try {
            Document doc = Jsoup.connect(url).get();
            Elements content = doc.select("p"); // get paragraphs
            Elements availableLinksOnPage = doc.select("a[href]");
            // System.out.println("Discovered: " + availableLinksOnPage);
            for (Element element : availableLinksOnPage) {
                String documentURL = element.attr("abs:href");
                if (!visitedURLs.contains(documentURL)) {
                    urls.add(documentURL);
                }

            }
            return content;
        } catch (IOException e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * The artifact locally stores the document, and returns the file path of the stored document
     */
    private String storeDocument(String document) {
        String filename = "documents.xml";
        try {
            BufferedWriter writer = new BufferedWriter(new FileWriter(filename));
            writer.write(String.valueOf(document));
            writer.close();
        } catch (IOException e) {
            e.printStackTrace();
        }
        // for simplicity as it's saved in the root directory, I only return filename, not path
        return filename;
    }

    // for quick testing
    public static void main(String[] args) {
        HypermediaCrawler crawler = new HypermediaCrawler();
        crawler.init("https://api.interactions.ics.unisg.ch/hypermedia-environment/was/581b07c7dff45162");
        crawler.searchEnvironment("Monitor Temperature", new OpFeedbackParam<>());
    }
}
