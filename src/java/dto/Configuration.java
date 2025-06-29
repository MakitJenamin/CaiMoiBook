package dto;

public class Configuration {
    private int id;
    private String configKey;
    private String configValue;
    private String description;

    public Configuration() {
    }

    public Configuration(int id, String configKey, String configValue, String description) {
        this.id = id;
        this.configKey = configKey;
        this.configValue = configValue;
        this.description = description;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getConfigKey() {
        return configKey;
    }

    public void setConfigKey(String configKey) {
        this.configKey = configKey;
    }

    public String getConfigValue() {
        return configValue;
    }

    public void setConfigValue(String configValue) {
        this.configValue = configValue;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }
} 