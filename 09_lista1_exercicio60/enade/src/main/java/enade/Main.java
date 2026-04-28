package enade;

import java.util.HashMap;
import java.util.Map;

import io.javalin.Javalin;
import io.javalin.rendering.template.JavalinMustache;

public class Main {
    public static void main(String[] args) {
        var app = Javalin.create(config -> {
            config.fileRenderer(new JavalinMustache());
            config.routes.get("/", ctx -> ctx.result("Hello World"));
            config.routes.get("/template", ctx -> {
                Map<String, String> map = new HashMap<>(); 
                map.put("oi", String.valueOf("ola".indexOf('a')));
                ctx.render("/templates/index.html", map);
            });
        }).start(7070);

    }
}