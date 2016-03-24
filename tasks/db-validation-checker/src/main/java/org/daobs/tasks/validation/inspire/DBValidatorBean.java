package org.daobs.tasks.validation.inspire;

import org.apache.camel.Exchange;
import org.apache.camel.Header;
import org.springframework.dao.DataAccessException;

import java.sql.SQLException;

/**
 * @author csachot
 */
public class DBValidatorBean {

    /**
     * Metatadata id key in the exchange header
     */
    private static final String METADATA_ID_KEY = "documentIdentifier";
    /**
     * DBValidatorClient that queries the database to get the metadata's validation report
     */
    private DBValidatorClient dbValidatorClient;

    /**
     * Constructor
     *
     * @param postgresServiceValidatorClient DBValidatorClient that queries the database to get the metadata's validation report
     */
    public DBValidatorBean(DBValidatorClient postgresServiceValidatorClient) {
        this.dbValidatorClient = postgresServiceValidatorClient;
    }

    /**
     * Get the input message body and validate
     * it against the INSPIRE validation service.
     * The output body contains the validation report.
     * <p>
     * Headers are propagated.
     *
     * @param exchange
     */
    public void validateBody(
            @Header(METADATA_ID_KEY) String metadataId,
            Exchange exchange) {
        ValidationReport report = null;
        try {
            report = dbValidatorClient.validate(metadataId);
        } catch (DataAccessException | SQLException e) {
            e.printStackTrace();
        }
        exchange.getOut().setBody(report);
        exchange.getOut().setHeaders(exchange.getIn().getHeaders());
    }
}
