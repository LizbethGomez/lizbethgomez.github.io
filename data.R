# Generate sample dataset
set.seed(1234)
n <- 1000
drugs <- sample(c("Drug A", "Drug B", "Drug C"), n, replace = TRUE)
efficacy <- rnorm(n, mean = c(0.7, 0.8, 0.9)[match(drugs, c("Drug A", "Drug B", "Drug C"))], sd = 0.1)
side_effect <- rnorm(n, mean = c(0.1, 0.2, 0.3)[match(drugs, c("Drug A", "Drug B", "Drug C"))], sd = 0.05)
duration <- sample(1:12, n, replace = TRUE)

# Combine data into a data frame
data <- data.frame(drug = drugs, efficacy = efficacy, side_effect = side_effect, duration = duration)

# Save data as CSV file
write.csv(data, "pharma_data.csv", row.names = FALSE)

