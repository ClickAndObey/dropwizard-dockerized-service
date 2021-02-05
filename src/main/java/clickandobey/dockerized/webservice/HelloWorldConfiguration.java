package clickandobey.dockerized.webservice;

import io.dropwizard.Configuration;
import com.fasterxml.jackson.annotation.JsonProperty;

public class HelloWorldConfiguration extends Configuration {

    private boolean debug;

    @JsonProperty
    public boolean getDebug() {
        return debug;
    }

    @JsonProperty
    public void setDebug(boolean debug) {
        this.debug = debug;
    }

}
