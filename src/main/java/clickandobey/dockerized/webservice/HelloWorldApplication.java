package clickandobey.dockerized.webservice;

import io.dropwizard.Application;
import io.dropwizard.setup.Bootstrap;
import io.dropwizard.setup.Environment;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import clickandobey.dockerized.webservice.resources.HelloWorldResource;
import clickandobey.dockerized.webservice.health.HelloWorldHealthCheck;

public class HelloWorldApplication extends Application<HelloWorldConfiguration> {

    public static final Logger LOGGER = LoggerFactory.getLogger(HelloWorldApplication.class);

    public static void main(String[] args) throws Exception {
        new HelloWorldApplication().run(args);
    }

    @Override
    public String getName() {
        return "hello-world";
    }

    @Override
    public void initialize(Bootstrap<HelloWorldConfiguration> bootstrap) {
        // nothing to do yet
    }

    @Override
    public void run(HelloWorldConfiguration configuration,
                    Environment environment) {
        addResources(configuration, environment);
        addHealthChecks(configuration, environment);
    }

    private void addHealthChecks(HelloWorldConfiguration configuration,
                                 Environment environment) {
        final HelloWorldHealthCheck healthCheck =
                new HelloWorldHealthCheck("hello");
        environment.healthChecks().register("hello", healthCheck);
    }

    private void addResources(HelloWorldConfiguration configuration,
                              Environment environment) {
        final HelloWorldResource resource = new HelloWorldResource();
        environment.jersey().register(resource);
    }

}