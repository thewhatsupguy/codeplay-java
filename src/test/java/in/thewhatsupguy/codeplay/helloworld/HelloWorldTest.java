package in.thewhatsupguy.codeplay.helloworld;

import java.io.ByteArrayOutputStream;
import java.io.PrintStream;
import org.junit.Test;
import org.junit.Before;
import org.junit.After;
import static org.junit.Assert.*;

public class HelloWorldTest {

    private final ByteArrayOutputStream outContent = new ByteArrayOutputStream();
    private final ByteArrayOutputStream errContent = new ByteArrayOutputStream();

    @Before
        public void setUpStreams() {
            System.setOut(new PrintStream(outContent));
            System.setErr(new PrintStream(errContent));
        }

    @After
        public void cleanUpStreams() {
            System.setOut(null);
            System.setErr(null);
        }

    @Test
        public void testHelloWorld() {
            HelloWorld.main(new String[] {});
            assertEquals("Hello World\n", outContent.toString());
        }
}
