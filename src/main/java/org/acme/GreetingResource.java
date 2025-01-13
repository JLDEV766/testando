package org.acme;

import com.fasterxml.jackson.databind.ObjectMapper;
import jakarta.ws.rs.*;
import jakarta.ws.rs.core.MediaType;

import java.util.HashMap;
import java.util.Map;

@Path("/hello")
public class GreetingResource {

    private final ObjectMapper objectMapper = new ObjectMapper();

    @GET
    @Produces(MediaType.APPLICATION_JSON)
    public String teste(
            @QueryParam("code") String code,
            @QueryParam("state") String state
    ) {
        try {
            // Criando um mapa para armazenar os parâmetros
            Map<String, String> queryParams = new HashMap<>();
            queryParams.put("code", code);
            queryParams.put("state", state);

            // Convertendo o mapa em JSON
            return objectMapper.writeValueAsString(queryParams);

        } catch (Exception e) {
            return "{\"error\":\"Falha ao converter os parâmetros\"}";
        }
    }

}
