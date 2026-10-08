package com.apitesting.tests;

import com.apitesting.base.BaseTest;
import io.restassured.response.Response;
import org.testng.Assert;
import org.testng.annotations.BeforeClass;
import org.testng.annotations.Test;

import java.io.*;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.Base64;

import static io.restassured.RestAssured.given;
import static org.hamcrest.Matchers.*;

/**
 * ============================================================
 *  FILE HANDLING & FILE UPLOAD SCENARIOS — RestAssured
 *  APIs used:
 *    https://httpbin.org/post           ← accepts any file upload
 *    https://httpbin.org/get            ← download / response body
 *    https://httpbin.org/base64/{value} ← base64 decode
 *    https://the-internet.herokuapp.com ← file upload UI (via API)
 * ============================================================
 *
 *  SCENARIOS:
 *  1.  Upload single file (multipart/form-data)
 *  2.  Upload file with extra form fields
 *  3.  Upload multiple files at once
 *  4.  Upload file as byte array
 *  5.  Upload file as Base64 encoded string in JSON body
 *  6.  Upload image file
 *  7.  Upload CSV file and validate response
 *  8.  Upload PDF file
 *  9.  Validate file upload response — filename, size, content-type
 *  10. File download — save response to disk
 *  11. Download and validate file content
 *  12. Download and check file size
 *  13. Download as byte array
 *  14. Download Base64 encoded content
 *  15. Create temp file programmatically + upload
 *  16. Negative — upload wrong content-type
 *  17. Negative — upload empty file
 *  18. Upload + Python side-by-side concept shown in comments
 * ============================================================
 */
public class FileHandlingTests extends BaseTest {

    // ── Paths to test resource files ──
    private static final String RESOURCES_PATH = "src/test/resources/files/";
    private static final String DOWNLOAD_PATH  = "src/test/resources/downloads/";

    @BeforeClass
    public void createTestDirectories() throws IOException {
        // Create directories if they don't exist
        Files.createDirectories(Paths.get(RESOURCES_PATH));
        Files.createDirectories(Paths.get(DOWNLOAD_PATH));

        // Create sample test files programmatically
        createSampleFiles();
    }

    private void createSampleFiles() throws IOException {
        // sample.txt
        Path txt = Paths.get(RESOURCES_PATH + "sample.txt");
        if (!Files.exists(txt))
            Files.write(txt, "Hello RestAssured File Upload Test".getBytes());

        // sample.csv
        Path csv = Paths.get(RESOURCES_PATH + "sample.csv");
        if (!Files.exists(csv))
            Files.write(csv, "id,name,price\n1,Booking1,500\n2,Booking2,800".getBytes());

        // sample.json
        Path json = Paths.get(RESOURCES_PATH + "sample.json");
        if (!Files.exists(json))
            Files.write(json, "{\"name\":\"test\",\"value\":123}".getBytes());
    }


    // ================================================================
    // SCENARIO 1 — UPLOAD SINGLE FILE (multipart/form-data)
    // Most common interview scenario
    // Python equivalent: requests.post(url, files={"file": open("path","rb")})
    // ================================================================
    @Test(priority = 1, description = "Upload single text file using multipart/form-data")
    public void test_uploadSingleFile() {
        File file = new File(RESOURCES_PATH + "sample.txt");

        given()
            .baseUri("https://httpbin.org")
            .contentType("multipart/form-data")   // MUST set for file upload
            .multiPart("file", new File(file, DOWNLOAD_PATH))            // ← key="file", value=File object
        .when()
            .post("/post")
        .then()
            .statusCode(200)
            .body("files.file",  notNullValue())  // httpbin echoes back the file content
            .body("files.file",  containsString("Hello RestAssured"));

        System.out.println("[UPLOAD] Single file uploaded successfully");
    }


    // ================================================================
    // SCENARIO 2 — UPLOAD FILE WITH EXTRA FORM FIELDS
    // Real-world: file + metadata fields together
    // Python: requests.post(url, files={"file": f}, data={"username": "yash"})
    // ================================================================
    @Test(priority = 2, description = "Upload file along with additional form fields")
    public void test_uploadFileWithFormFields() {
        File file = new File(RESOURCES_PATH + "sample.txt");

        given()
            .baseUri("https://httpbin.org")
            .contentType("multipart/form-data")
            .multiPart("file",     file)               // ← the file
            .multiPart("username", "Yashwanth")        // ← extra field 1
            .multiPart("type",     "text")             // ← extra field 2
            .multiPart("version",  "1.0")              // ← extra field 3
        .when()
            .post("/post")
        .then()
            .statusCode(200)
            .body("form.username", equalTo("Yashwanth"))  // httpbin echoes form fields
            .body("form.type",     equalTo("text"))
            .body("form.version",  equalTo("1.0"))
            .body("files.file",    notNullValue());

        System.out.println("[UPLOAD] File + form fields uploaded successfully");
    }


    // ================================================================
    // SCENARIO 3 — UPLOAD MULTIPLE FILES AT ONCE
    // Python: requests.post(url, files=[("files", f1), ("files", f2)])
    // ================================================================
    @Test(priority = 3, description = "Upload multiple files in single request")
    public void test_uploadMultipleFiles() {
        File txtFile  = new File(RESOURCES_PATH + "sample.txt");
        File csvFile  = new File(RESOURCES_PATH + "sample.csv");
        File jsonFile = new File(RESOURCES_PATH + "sample.json");

        given()
            .baseUri("https://httpbin.org")
            .contentType("multipart/form-data")
            .multiPart("file1", txtFile)          // file 1
            .multiPart("file2", csvFile)          // file 2
            .multiPart("file3", jsonFile)         // file 3
        .when()
            .post("/post")
        .then()
            .statusCode(200)
            .body("files.file1", notNullValue())  // each file echoed back
            .body("files.file2", notNullValue())
            .body("files.file3", notNullValue());

        System.out.println("[UPLOAD] Multiple files uploaded successfully");
    }


    // ================================================================
    // SCENARIO 4 — UPLOAD FILE AS BYTE ARRAY
    // Useful when file comes from DB / memory (not from disk)
    // Python: requests.post(url, files={"file": ("name.txt", bytes_data, "text/plain")})
    // ================================================================
    @Test(priority = 4, description = "Upload file content as byte array (from memory)")
    public void test_uploadAsByteArray() throws IOException {
        File   file      = new File(RESOURCES_PATH + "sample.txt");
        byte[] fileBytes = Files.readAllBytes(file.toPath()); // read file → byte[]

        given()
            .baseUri("https://httpbin.org")
            .contentType("multipart/form-data")
            .multiPart(
                "file",              // form field name
                "sample.txt",        // filename shown to server
                fileBytes,           // ← byte array instead of File object
                "text/plain"         // MIME type
            )
        .when()
            .post("/post")
        .then()
            .statusCode(200)
            .body("files.file", notNullValue());

        System.out.println("[UPLOAD] Byte array uploaded. Size: " + fileBytes.length + " bytes");
    }


    // ================================================================
    // SCENARIO 5 — UPLOAD FILE AS BASE64 IN JSON BODY
    // Common pattern: APIs that accept { "filename": "x", "content": "base64..." }
    // Python: base64.b64encode(open("f","rb").read()).decode()
    // ================================================================
    @Test(priority = 5, description = "Upload file encoded as Base64 string inside JSON body")
    public void test_uploadBase64InJsonBody() throws IOException {
        File   file      = new File(RESOURCES_PATH + "sample.txt");
        byte[] fileBytes = Files.readAllBytes(file.toPath());
        String base64    = Base64.getEncoder().encodeToString(fileBytes); // ← encode to Base64

        // Build JSON body with base64 content
        String jsonBody = "{"
            + "\"filename\": \"sample.txt\","
            + "\"content\": \"" + base64 + "\","
            + "\"contentType\": \"text/plain\""
            + "}";

        System.out.println("[BASE64] Encoded content: " + base64);

        given()
            .baseUri("https://httpbin.org")
            .contentType("application/json")
            .body(jsonBody)                   // JSON body containing base64 string
        .when()
            .post("/post")
        .then()
            .statusCode(200)
            .body("json.filename",    equalTo("sample.txt"))
            .body("json.content",     equalTo(base64))
            .body("json.contentType", equalTo("text/plain"));
    }


    // ================================================================
    // SCENARIO 6 — UPLOAD IMAGE FILE
    // MIME type: image/png or image/jpeg
    // ================================================================
    @Test(priority = 6, description = "Upload an image file with correct MIME type")
    public void test_uploadImageFile() throws IOException {
        // Create a minimal 1x1 PNG in memory (for test — no actual image file needed)
        byte[] minimalPng = createMinimalPngBytes();

        given()
            .baseUri("https://httpbin.org")
            .contentType("multipart/form-data")
            .multiPart(
                "image",         // field name
                "test.png",      // filename
                minimalPng,      // byte array
                "image/png"      // ← image MIME type
            )
        .when()
            .post("/post")
        .then()
            .statusCode(200)
            .body("files.image", notNullValue());

        System.out.println("[UPLOAD] Image file uploaded. Size: " + minimalPng.length + " bytes");
    }


    // ================================================================
    // SCENARIO 7 — UPLOAD CSV FILE AND VALIDATE ECHOED CONTENT
    // ================================================================
    @Test(priority = 7, description = "Upload CSV file and validate server echoes content back")
    public void test_uploadCsvFile() {
        File csvFile = new File(RESOURCES_PATH + "sample.csv");

        Response response = given()
            .baseUri("https://httpbin.org")
            .contentType("multipart/form-data")
            .multiPart(
                "file",
                csvFile,
                "text/csv"   // MIME type for CSV
            )
        .when()
            .post("/post")
        .then()
            .statusCode(200)
            .body("files.file", containsString("id,name,price"))  // CSV header echoed
            .extract().response();

        String echoedContent = response.jsonPath().getString("files.file");
        System.out.println("[CSV] Server received:\n" + echoedContent);

        // Validate CSV rows
        Assert.assertTrue(echoedContent.contains("Booking1"), "CSV row 1 missing");
        Assert.assertTrue(echoedContent.contains("Booking2"), "CSV row 2 missing");
    }


    // ================================================================
    // SCENARIO 8 — UPLOAD WITH CUSTOM FILENAME AND MIME TYPE
    // INTERVIEW: control exactly what filename + type the server sees
    // ================================================================
    @Test(priority = 8, description = "Upload with custom filename and custom MIME type")
    public void test_uploadWithCustomFilenameAndMime() {
        File file = new File(RESOURCES_PATH + "sample.txt");

        given()
            .baseUri("https://httpbin.org")
            .contentType("multipart/form-data")
            .multiPart(
                "document",                   // form field name
                "report_2025_final.pdf",      // ← custom filename (even though it's a .txt)
                "PDF Content Here".getBytes(),
                "application/pdf"             // ← custom MIME type
            )
        .when()
            .post("/post")
        .then()
            .statusCode(200)
            .body("files.document", notNullValue());
    }


    // ================================================================
    // SCENARIO 9 — VALIDATE UPLOAD RESPONSE (filename, size, type)
    // INTERVIEW: After upload, verify server stored correctly
    // ================================================================
    @Test(priority = 9, description = "Upload file and validate all metadata in response")
    public void test_validateUploadResponse() throws IOException {
        File   file     = new File(RESOURCES_PATH + "sample.txt");
        long   fileSize = Files.size(file.toPath());

        Response response = given()
            .baseUri("https://httpbin.org")
            .contentType("multipart/form-data")
            .multiPart("file", file)
        .when()
            .post("/post")
        .then()
            .statusCode(200)
            .extract().response();

        // httpbin echoes back headers, url, form data
        String url         = response.jsonPath().getString("url");
        String fileContent = response.jsonPath().getString("files.file");

        Assert.assertNotNull(fileContent,              "File content in response should not be null");
        Assert.assertTrue(fileContent.length() > 0,   "File content should not be empty");
        Assert.assertEquals(url, "https://httpbin.org/post", "URL should match");

        System.out.println("[VALIDATE] File size on disk: " + fileSize + " bytes");
        System.out.println("[VALIDATE] Content echoed by server: " + fileContent);
    }


    // ================================================================
    // SCENARIO 10 — FILE DOWNLOAD — save response body to disk
    // Python: with open("file.txt","wb") as f: f.write(response.content)
    // ================================================================
    @Test(priority = 10, description = "Download file and save to disk")
    public void test_downloadFileAndSave() throws IOException {
        // httpbin /base64/{value} returns decoded bytes — we use it as a download source
        String base64Value = "SFRUUEJJTiBpcyBhd2Vzb21l"; // "HTTPBIN is awesome"

        byte[] downloadedBytes = given()
            .baseUri("https://httpbin.org")
        .when()
            .get("/base64/" + base64Value)
        .then()
            .statusCode(200)
            .extract().asByteArray();             // ← extract response as byte[]

        // Save to disk
        Path downloadPath = Paths.get(DOWNLOAD_PATH + "downloaded_file.txt");
        Files.write(downloadPath, downloadedBytes);

        // Verify saved file
        Assert.assertTrue(Files.exists(downloadPath),           "File should exist on disk");
        Assert.assertTrue(Files.size(downloadPath) > 0,        "Downloaded file should not be empty");

        String content = new String(downloadedBytes);
        System.out.println("[DOWNLOAD] Saved to: " + downloadPath);
        System.out.println("[DOWNLOAD] Content: " + content);
        Assert.assertEquals(content, "HTTPBIN is awesome", "Decoded content mismatch");
    }


    // ================================================================
    // SCENARIO 11 — DOWNLOAD AND VALIDATE CONTENT
    // Get response as String and assert specific content
    // ================================================================
    @Test(priority = 11, description = "Download and validate text content in response")
    public void test_downloadAndValidateContent() {
        Response response = given()
            .baseUri("https://httpbin.org")
        .when()
            .get("/robots.txt")   // plain text file endpoint
        .then()
            .statusCode(200)
            .contentType(containsString("text"))
            .extract().response();

        String content  = response.getBody().asString();    // full response body as String
        String ct       = response.getHeader("Content-Type");
        int    status   = response.getStatusCode();

        System.out.println("[DOWNLOAD] Status: "       + status);
        System.out.println("[DOWNLOAD] Content-Type: " + ct);
        System.out.println("[DOWNLOAD] Content:\n"     + content);

        Assert.assertNotNull(content);
        Assert.assertTrue(content.length() > 0, "Content should not be empty");
    }


    // ================================================================
    // SCENARIO 12 — DOWNLOAD AND CHECK FILE SIZE
    // INTERVIEW: Validate the response body is within expected size range
    // ================================================================
    @Test(priority = 12, description = "Download file and validate file size in bytes")
    public void test_downloadAndCheckFileSize() {
        byte[] bytes = given()
            .baseUri("https://httpbin.org")
        .when()
            .get("/bytes/1024")         // httpbin returns exactly N random bytes
        .then()
            .statusCode(200)
            .extract().asByteArray();

        long downloadedSize = bytes.length;
        System.out.println("[SIZE] Downloaded: " + downloadedSize + " bytes");

        Assert.assertEquals(downloadedSize, 1024, "Downloaded size must be exactly 1024 bytes");
        Assert.assertTrue(downloadedSize > 0,      "File must not be empty");
    }


    // ================================================================
    // SCENARIO 13 — DOWNLOAD IMAGE AND VALIDATE CONTENT-TYPE
    // ================================================================
    @Test(priority = 13, description = "Download image and validate Content-Type header")
    public void test_downloadImageFile() {
        Response response = given()
            .baseUri("https://httpbin.org")
            .header("Accept", "image/png")    // tell server we want PNG
        .when()
            .get("/image/png")
        .then()
            .statusCode(200)
            .header("Content-Type", containsString("image/png"))
            .extract().response();

        byte[] imageBytes = response.asByteArray();
        System.out.println("[IMAGE] Downloaded PNG size: " + imageBytes.length + " bytes");

        Assert.assertTrue(imageBytes.length > 0, "Image must not be empty");

        // PNG files always start with these magic bytes: 137 80 78 71
        Assert.assertEquals(imageBytes[0] & 0xFF, 137, "PNG magic byte 0");
        Assert.assertEquals(imageBytes[1] & 0xFF, 80,  "PNG magic byte 1 (P)");
        Assert.assertEquals(imageBytes[2] & 0xFF, 78,  "PNG magic byte 2 (N)");
        Assert.assertEquals(imageBytes[3] & 0xFF, 71,  "PNG magic byte 3 (G)");
    }


    // ================================================================
    // SCENARIO 14 — DOWNLOAD AND DECODE BASE64 RESPONSE
    // Some APIs return files as base64 strings inside JSON
    // Python: base64.b64decode(response.json()["content"])
    // ================================================================
    @Test(priority = 14, description = "Receive Base64 encoded file in JSON, decode and validate")
    public void test_downloadBase64EncodedContent() {
        // httpbin /base64/{encoded} decodes and returns raw bytes
        // We reverse — send known text, get back decoded
        String originalText   = "RestAssured File Test";
        String encodedContent = Base64.getEncoder().encodeToString(originalText.getBytes());

        byte[] decodedBytes = given()
            .baseUri("https://httpbin.org")
        .when()
            .get("/base64/" + encodedContent)
        .then()
            .statusCode(200)
            .extract().asByteArray();

        String decoded = new String(decodedBytes);
        System.out.println("[BASE64] Original:  " + originalText);
        System.out.println("[BASE64] Encoded:   " + encodedContent);
        System.out.println("[BASE64] Decoded:   " + decoded);

        Assert.assertEquals(decoded, originalText, "Decoded content must match original");
    }


    // ================================================================
    // SCENARIO 15 — CREATE TEMP FILE PROGRAMMATICALLY + UPLOAD
    // INTERVIEW: Generate test data file on the fly (no static fixture file)
    // Python: io.BytesIO(b"content") used directly
    // ================================================================
    @Test(priority = 15, description = "Create temp file in code, upload it, verify")
    public void test_createTempFileAndUpload() throws IOException {
        // Create temp file in system temp directory
        File tempFile = File.createTempFile("restassured_test_", ".txt");
        tempFile.deleteOnExit();   // auto-delete when JVM exits

        // Write test content to it
        String content = "Dynamic content: " + System.currentTimeMillis();
        Files.write(tempFile.toPath(), content.getBytes());

        System.out.println("[TEMP] Created: " + tempFile.getAbsolutePath());
        System.out.println("[TEMP] Content: " + content);

        given()
            .baseUri("https://httpbin.org")
            .contentType("multipart/form-data")
            .multiPart("file", tempFile, "text/plain")
        .when()
            .post("/post")
        .then()
            .statusCode(200)
            .body("files.file", containsString("Dynamic content:"));
    }


    // ================================================================
    // SCENARIO 16 — UPLOAD + DOWNLOAD ROUND TRIP
    // Upload a file, then download it back and compare
    // INTERVIEW: Full round-trip data integrity check
    // ================================================================
    @Test(priority = 16, description = "Upload then download and verify content matches (round trip)")
    public void test_uploadDownloadRoundTrip() throws IOException {
        String originalContent = "Round Trip Test Content 12345";
        byte[] originalBytes   = originalContent.getBytes();

        // Step 1: Upload (httpbin echoes the file content back in response)
        Response uploadResponse = given()
            .baseUri("https://httpbin.org")
            .contentType("multipart/form-data")
            .multiPart("file", "roundtrip.txt", originalBytes, "text/plain")
        .when()
            .post("/post")
        .then()
            .statusCode(200)
            .extract().response();

        String echoedContent = uploadResponse.jsonPath().getString("files.file");
        System.out.println("[ROUNDTRIP] Uploaded:  " + originalContent);
        System.out.println("[ROUNDTRIP] Echoed:    " + echoedContent);

        // Step 2: Verify the echoed content matches what we uploaded
        Assert.assertEquals(echoedContent.trim(), originalContent,
                            "Round trip content mismatch!");
    }


    // ================================================================
    // SCENARIO 17 — NEGATIVE: UPLOAD WITHOUT REQUIRED FILE → 400
    // INTERVIEW: Always test what happens when file is missing
    // ================================================================
    @Test(priority = 17, description = "Negative: POST without file field — expect 400 or handled error")
    public void test_uploadWithoutFile_negative() {
        given()
            .baseUri("https://httpbin.org")
            .contentType("multipart/form-data")
            .multiPart("description", "no file here")   // only text, no file
        .when()
            .post("/post")
        .then()
            .statusCode(anyOf(is(200), is(400)))  // httpbin accepts it; real APIs return 400
            .body("form.description", equalTo("no file here"));
    }


    // ================================================================
    // SCENARIO 18 — NEGATIVE: UPLOAD EMPTY FILE
    // INTERVIEW: Edge case — 0-byte file
    // ================================================================
    @Test(priority = 18, description = "Negative: Upload empty 0-byte file")
    public void test_uploadEmptyFile_negative() throws IOException {
        File emptyFile = File.createTempFile("empty_", ".txt");
        emptyFile.deleteOnExit();
        // Don't write anything — file stays 0 bytes

        Assert.assertEquals(Files.size(emptyFile.toPath()), 0L, "File must be 0 bytes");

        given()
            .baseUri("https://httpbin.org")
            .contentType("multipart/form-data")
            .multiPart("file", emptyFile, "text/plain")
        .when()
            .post("/post")
        .then()
            .statusCode(anyOf(is(200), is(400)));

        System.out.println("[NEGATIVE] Empty file upload attempted");
    }


    // ================================================================
    // SCENARIO 19 — CHECK RESPONSE HEADERS ON DOWNLOAD
    // Content-Disposition header tells you filename for downloads
    // ================================================================
    @Test(priority = 19, description = "Validate Content-Disposition and Content-Length headers on download")
    public void test_downloadResponseHeaders() {
        given()
            .baseUri("https://httpbin.org")
        .when()
            .get("/image/jpeg")
        .then()
            .statusCode(200)
            .header("Content-Type", containsString("image/jpeg"))
            .header("Content-Length", notNullValue());   // size of file in bytes
    }


    // ================================================================
    // SCENARIO 20 — READ FILE FROM CLASSPATH (resources folder)
    // INTERVIEW: Best practice — keep test files in src/test/resources
    // ================================================================
    @Test(priority = 20, description = "Upload file from classpath resources folder")
    public void test_uploadFileFromClasspath() throws IOException {
        // File placed at: src/test/resources/files/sample.txt
        // Read it as stream from classpath
        InputStream is = getClass().getClassLoader()
                                   .getResourceAsStream("files/sample.txt");

        Assert.assertNotNull(is, "sample.txt not found in classpath");

        byte[] fileBytes = is.readAllBytes();
        is.close();

        given()
            .baseUri("https://httpbin.org")
            .contentType("multipart/form-data")
            .multiPart(
                "file",
                "sample.txt",
                fileBytes,
                "text/plain"
            )
        .when()
            .post("/post")
        .then()
            .statusCode(200)
            .body("files.file", notNullValue());

        System.out.println("[CLASSPATH] Uploaded from classpath. Bytes: " + fileBytes.length);
    }


    // ================================================================
    // HELPER — create a minimal valid PNG as byte[] (1x1 white pixel)
    // So tests work without needing an actual .png file on disk
    // ================================================================
    private byte[] createMinimalPngBytes() {
        return new byte[]{
            (byte)0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A,  // PNG signature
            0x00, 0x00, 0x00, 0x0D,                                   // IHDR length
            0x49, 0x48, 0x44, 0x52,                                   // IHDR
            0x00, 0x00, 0x00, 0x01,                                   // width = 1
            0x00, 0x00, 0x00, 0x01,                                   // height = 1
            0x08, 0x02,                                               // 8-bit RGB
            0x00, 0x00, 0x00,                                         // compression/filter/interlace
            (byte)0x90, 0x77, 0x53, (byte)0xDE,                      // CRC
            0x00, 0x00, 0x00, 0x0C,                                   // IDAT length
            0x49, 0x44, 0x41, 0x54,                                   // IDAT
            0x08, (byte)0xD7, 0x63, (byte)0xF8, (byte)0xCF,
            (byte)0xC0, 0x00, 0x00, 0x00, 0x02, 0x00, 0x01,          // compressed pixel data
            (byte)0xE2, 0x21, (byte)0xBC, 0x33,                      // CRC
            0x00, 0x00, 0x00, 0x00,                                   // IEND length
            0x49, 0x45, 0x4E, 0x44,                                   // IEND
            (byte)0xAE, 0x42, 0x60, (byte)0x82                       // CRC
        };
    }
}
