package clickandobey.dockerized.webservice.resources;

import clickandobey.dockerized.webservice.api.Representation;
import com.codahale.metrics.annotation.Timed;

import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.QueryParam;
import javax.ws.rs.core.MediaType;
import java.util.concurrent.atomic.AtomicLong;
import java.util.Optional;

@Path("/hello")
@Produces(MediaType.APPLICATION_JSON)
public class HelloWorldResource {
    private final transient AtomicLong counter;

    public HelloWorldResource() {
        this.counter = new AtomicLong();
    }

    @GET
    @Timed
    public Representation sayHello(@QueryParam("name") Optional<String> name) {
        return new Representation(counter.incrementAndGet(), "Hello");
    }
}
