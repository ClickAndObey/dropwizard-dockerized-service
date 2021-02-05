package clickandobey.dockerized.webservice.api;

import com.fasterxml.jackson.annotation.JsonProperty;

public class Representation {
    private long id;

    private String content;

    public Representation() {
        // Jackson deserialization
    }

    public Representation(long id, String content) {
        this.id = id;
        this.content = content;
    }

    @JsonProperty
    public long getId() {
        return id;
    }

    public void setId(long id) {
        this.id = id;
    }

    @JsonProperty
    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

}
