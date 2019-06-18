#In Tools -> global Options -> GIT/SVN get git.exe path, something like:C:/Users/qingye.yuan/AppData/Local/GitHub/PortableGit_69bd5e6f85e4842f07db71c9618a621154c52254/bin/git.exe
#if you don't have id_rsa.pub key; using file.exists("~/.ssh/id_rsa.pub") to check, then create one using rstudio.
#copy your key to github website your account.
#change settings in project Options fill in the current git repo path of your project there

## MAKE FIGURES ####
# By group
data.plot = ggplot(data, aes(x = group, y = rt)) +
  geom_boxplot()
pdf("figures/data.pdf")
data.plot
dev.off()