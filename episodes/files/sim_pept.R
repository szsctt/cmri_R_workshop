#### simulate data for case study ####

# simulate counts of peptides from synthesised library

# simulate 10,000 7-mer peptide sequences and their count in
# plasmid, vector, entry and expression libraries


#### load libraries ####

library(tidyverse)
library(Biostrings)

n_pept <- 10000
noise_mean <- 1
noise_sd <- 0.03

out_path <- here::here("episodes", "data")

amino_acids <- names(AMINO_ACID_CODE[1:20])

res <- tibble(
  # count in plasmid library is flat exponential
  plasmid_count = rexp(n_pept, rate=1000) * 3000 * rnorm(n_pept, mean=noise_mean, sd=noise_sd )
) %>%
  # 50% chance of packaging well
  mutate(good_packager = rbinom(n_pept, 1, 0.5)) %>%
  # decide if row is good packager or not
  mutate(vector_count = case_when(
    good_packager == 1 ~ plasmid_count * 2 * rnorm(n(), mean=noise_mean, sd=noise_sd),
    good_packager == 0 ~ plasmid_count * 0.5 * rnorm(n(), mean=noise_mean, sd=noise_sd )
  )) %>%
  # good packagers have a 2% chance of really good entry
  # good packagers have a 20% chance of good entry
  # bad packagers have a 2% chance of good entry
  mutate(good_entry = case_when(
    good_packager == 1 & rbinom(n_pept, 1, 0.02) == 1 ~ "really_good",
    good_packager == 1 & rbinom(n_pept, 1, 0.2) == 1 ~ "good",
    good_packager == 0  & rbinom(n_pept, 1, 0.02) == 1 ~ "good",
    TRUE ~ "bad"
  )) %>%
  # create counts for entry from vector
  mutate(entry_count = case_when(
    good_entry == "really_good" ~ vector_count * 5 * rnorm(n(), mean=noise_mean, sd=noise_sd),
    good_entry == "good" ~ vector_count * 1.5 * rnorm(n(), mean=noise_mean, sd=noise_sd),
    good_entry == "bad" ~ vector_count * 0.3 * rnorm(n(), mean=noise_mean, sd=noise_sd)
  )) %>%
  # good and very good entry have 2% chance of very good expression
  # good and very good entry have 20% chance of good expression
  # bad entry have 2% chance of good expression
  mutate(good_expression = case_when(
    good_entry %in% c("really_good", "good") & rbinom(n_pept, 1, 0.02) == 1 ~ "really_good",
    good_entry %in% c("really_good", "good") & rbinom(n_pept, 1, 0.20) == 1 ~ "good",
    good_entry %in% c("bad") & rbinom(n_pept, 1, 0.02) == 1 ~ "good",
    TRUE ~ "bad"
  )) %>%
  # create counts for expression from entry
  mutate(expression_count = case_when(
    good_expression == "really_good" ~ entry_count * 10 * rnorm(n(), mean=noise_mean, sd=noise_sd),
    good_expression == "good" ~ entry_count * 1.5 * rnorm(n(), mean=noise_mean, sd=noise_sd),
    good_expression == "bad" ~ entry_count * 0.3 * rnorm(n(), mean=noise_mean, sd=noise_sd)
  )) %>%
  # generate random 7-mers for each row
  rowwise() %>%
  mutate(peptide = list(sample(amino_acids, 7, replace=TRUE))) %>%
  mutate(peptide = paste0(peptide, collapse="")) %>%
  ungroup() %>%
  # remove columns we used to generate counts
  select(-contains("good")) %>%
  # pivot longer
  pivot_longer(contains("count"), names_to = "lib", names_pattern = "(plasmid|vector|entry|expression)", values_to="count") %>%
  # count must be whole number
  mutate(count = round(count) + 1)


# calculate total count for each library
res %>%
  group_by(lib) %>%
  summarise(size = sum(count))

# plot counts
res %>%
  # rank peptides within library
  group_by(lib) %>%
  arrange(desc(count)) %>%
  mutate(peptide = row_number()) %>%
  # plot count vs peptide
  ggplot(aes(x=peptide, y=count)) +
  geom_point() +
  facet_wrap(vars(lib), scales="free")

# save individual files for each library
for (l in unique(res$lib)) {
  res %>%
    # get only rows for this library
    filter(lib == l) %>%
    # remove library column
    select(-lib) %>%
    # randomize order of rows
    slice_sample(prop=1) %>%
    # write file
    write_tsv(file.path(out_path, glue::glue("counts_{l}.tsv")))
}

