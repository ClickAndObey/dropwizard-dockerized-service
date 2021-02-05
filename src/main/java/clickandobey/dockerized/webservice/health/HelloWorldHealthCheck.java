package clickandobey.dockerized.webservice.health;

import com.codahale.metrics.health.HealthCheck;

public class HelloWorldHealthCheck extends HealthCheck {
    private final transient String content;

    public HelloWorldHealthCheck(String content) {
        this.content = content;
    }

    @Override
    protected Result check() throws Exception {
        if (!content.contains("hello")) {
            return Result.unhealthy("Content doesn't include a hello!");
        }
        return Result.healthy();
    }
}
