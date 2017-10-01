library(shiny)

shinyServer(function(input, output) {
  
  output$download_report <- downloadHandler(
    filename = function() { 
      "output.pdf" 
    },
    content = function(plot_file) {
      file_out = isolate(input$file1)
      file_outallele = isolate(input$file2)
      
      if (is.null(file_out) || is.null(file_outallele)){
        return(NULL)
      } 
      
      out.dat = read.table(file_out$datapath,sep="\n",stringsAsFactors=FALSE);
      outallele.dat = read.table(file_outallele$datapath,sep="\n",stringsAsFactors=FALSE);
      
      #default values
      ##out.raw
      no.sims.default = 3
      no.years.default = 25
      start.non.native.after.year.default = 20
      stop.non.native.after.year.default = 500
      yearly.inputs.default = "No"
      yearly.inputs.mean.default = 0 
      yearly.inputs.stdev.default = 0 
      yearly.inputs.into.stage.default = "none" 
      large.scale.inputs.default = "No"
      large.scale.inputs.mean.default = 0
      large.scale.inputs.stdev.default = 0
      large.scale.inputs.freq.default = 0
      large.scale.input.into.stage.default = "none"
      non.native.mf.ratio.default = "50:50"
      habitat.size.default = 13000
      no.loci.default = 10
      loci.dist.default = "exponential 3 sets"
      selection.default = "On"
      pop.crash.default = "On"
      pop.crash.start.year.default = 10
      pop.crash.fish.stage.default = 0
      pop.crash.mort.prop.default = 99
      
      #detach variables
      variables.dat = out.dat[c(13:29),1];
      printing.variables = variables.dat;
      no.sims = as.numeric(sub("Number of simulations: ","",variables.dat[1]));
      no.years = as.numeric(sub("Number of model years: ","",variables.dat[2]));
      start.non.native.after.year = as.numeric(sub("Start non-native inputs after year: ","",variables.dat[3]));
      stop.non.native.after.year = as.numeric(sub("Stop  non-native inputs after year: ","",variables.dat[4]));
      yearly.inputs = sub("Yearly inputs[?] ","",variables.dat[5]);
      variables.dat[6] = sub("Yearly inputs, mean: ","",variables.dat[6]); variables.dat[6] = sub("stdev: ","",variables.dat[6]);
      yearly.inputs.mean = as.numeric(strsplit(variables.dat[6]," ")[[1]][1]);
      yearly.inputs.stdev = as.numeric(strsplit(variables.dat[6]," ")[[1]][2]); 
      yearly.inputs.into.stage = sub(" ","",sub("Yearly inputs into stage: ","",variables.dat[7])); ##also strips trailing white space
      large.scale.inputs = sub("Large scale inputs[?] ","",variables.dat[8])
      variables.dat[9] = sub("Large scale inputs, mean: ","",variables.dat[9]); variables.dat[9] = sub("stdev: ","",variables.dat[9]);
      large.scale.inputs.mean = as.numeric(strsplit(variables.dat[9]," ")[[1]][1]);
      large.scale.inputs.stdev = as.numeric(strsplit(variables.dat[9]," ")[[1]][2]);                                                                                 
      large.scale.inputs.freq = as.numeric(sub(" years","",sub("Large scale inputs frequency, every ","",variables.dat[10])));
      large.scale.input.into.stage = sub("Large scale input into stage: ","",variables.dat[11]);
      non.native.mf.ratio = sub("Non-native male:female sex ratio: ","",variables.dat[12]);
      habitat.size = as.numeric(sub("Habitat size [(]sq m[)]: ","",variables.dat[13]));
      no.loci = as.numeric(sub("Number of QTL loci: ","",variables.dat[14]));
      loci.dist = sub("Loci distribution: ","",variables.dat[15]);
      selection = sub("Selection: ","",variables.dat[16]);
      variables.dat[17] = strsplit(variables.dat[17],":")
      pop.crash = sub(" ","",sub("[.] Start year","",variables.dat[17][[1]][2]));
      pop.crash.start.year = as.numeric(sub(" ","",sub("[,] Fish stage","",variables.dat[17][[1]][3])));
      pop.crash.fish.stage = as.numeric(sub(" ","",sub("[,] Mortality proportion","",variables.dat[17][[1]][4])));
      pop.crash.mort.prop = as.numeric(sub(" ","",variables.dat[17][[1]][5]));
      
      ##loci.effects
      start.loci.row = 32
      finish.loci.row = start.loci.row+no.loci-1
      loci.effects = out.dat[c(start.loci.row:finish.loci.row),1]
      loci.effects = sapply(strsplit(loci.effects,"\t"),as.numeric)
      loci.effects = data.frame(t(loci.effects))
      colnames(loci.effects) = c("loci","effects")
      
      ##class.numbers
      start.class.number.row = finish.loci.row+3;
      finish.class.number.row = start.class.number.row+no.years;
      class.number = out.dat[c(start.class.number.row:finish.class.number.row),1]
      class.number = sapply(strsplit(class.number,"\t"),as.numeric)
      class.number = data.frame(t(class.number))
      colnames(class.number) = c("year","spawn","eggs","parr","smolts","adults")
      
      ##nonnative.inputss
      start.nonnative.inputs.row = finish.class.number.row+3;
      finish.nonnative.inputs.row = start.nonnative.inputs.row+no.years-1;
      nonnative.inputs = out.dat[c(start.nonnative.inputs.row:finish.nonnative.inputs.row),1]
      nonnative.inputs = sapply(strsplit(nonnative.inputs,"\t"),as.numeric)
      nonnative.inputs = data.frame(t(nonnative.inputs))
      colnames(nonnative.inputs) = c("year","spawn","eggs","parr","smolts","adults")
      
      ##class1.parr.age.mean.fish
      start.class1.parr.age.mean.fish.row = finish.nonnative.inputs.row+3;
      finish.class1.parr.age.mean.fish.row = start.class1.parr.age.mean.fish.row+no.years-1;
      class1.parr.age.mean.fish = out.dat[c(start.class1.parr.age.mean.fish.row:finish.class1.parr.age.mean.fish.row),1]
      class1.parr.age.mean.fish = sapply(strsplit(class1.parr.age.mean.fish,"\t"),as.numeric)
      class1.parr.age.mean.fish = data.frame(t(class1.parr.age.mean.fish))
      colnames(class1.parr.age.mean.fish) = c("year","age_0","age_1","age_2","age_3","age_4","age_5","age_6","age_7","age_8","age_9")
      
      ##class1.parr.length.mean.fish
      start.class1.parr.length.mean.fish.row = finish.class1.parr.age.mean.fish.row+3;
      finish.class1.parr.length.mean.fish.row = start.class1.parr.length.mean.fish.row+no.years-1;
      class1.parr.length.mean.fish = out.dat[c(start.class1.parr.length.mean.fish.row:finish.class1.parr.length.mean.fish.row),1]
      class1.parr.length.mean.fish = sapply(strsplit(class1.parr.length.mean.fish,"\t"),as.numeric)
      class1.parr.length.mean.fish = data.frame(t(class1.parr.length.mean.fish))
      colnames(class1.parr.length.mean.fish) = c("year","age_0","age_1","age_2","age_3","age_4","age_5","age_6","age_7","age_8","age_9")
      
      ##class2.smolts.age.mean.fish
      start.class2.smolts.age.mean.fish.row = finish.class1.parr.length.mean.fish.row+3;
      finish.class2.smolts.age.mean.fish.row = start.class2.smolts.age.mean.fish.row+no.years-1;
      class2.smolts.age.mean.fish = out.dat[c(start.class2.smolts.age.mean.fish.row:finish.class2.smolts.age.mean.fish.row),1]
      class2.smolts.age.mean.fish = sapply(strsplit(class2.smolts.age.mean.fish,"\t"),as.numeric)
      class2.smolts.age.mean.fish = data.frame(t(class2.smolts.age.mean.fish))
      colnames(class2.smolts.age.mean.fish) = c("year","age_0","age_1","age_2","age_3","age_4","age_5","age_6","age_7","age_8","age_9")
      
      ##class2.smolts.length.mean.fish
      start.class2.smolts.length.mean.fish.row = finish.class2.smolts.age.mean.fish.row+3;
      finish.class2.smolts.length.mean.fish.row = start.class2.smolts.length.mean.fish.row+no.years-1;
      class2.smolts.length.mean.fish = out.dat[c(start.class2.smolts.length.mean.fish.row:finish.class2.smolts.length.mean.fish.row),1]
      class2.smolts.length.mean.fish = sapply(strsplit(class2.smolts.length.mean.fish,"\t"),as.numeric)
      class2.smolts.length.mean.fish = data.frame(t(class2.smolts.length.mean.fish))
      colnames(class2.smolts.length.mean.fish) = c("year","age_0","age_1","age_2","age_3","age_4","age_5","age_6","age_7","age_8","age_9")
      
      ##class4.spawners.age.mean.fish
      start.class4.spawners.age.mean.fish.row = finish.class2.smolts.length.mean.fish.row+3;
      finish.class4.spawners.age.mean.fish.row = start.class4.spawners.age.mean.fish.row+no.years-1;
      class4.spawners.age.mean.fish = out.dat[c(start.class4.spawners.age.mean.fish.row:finish.class4.spawners.age.mean.fish.row),1]
      class4.spawners.age.mean.fish = sapply(strsplit(class4.spawners.age.mean.fish,"\t"),as.numeric)
      class4.spawners.age.mean.fish = data.frame(t(class4.spawners.age.mean.fish))
      colnames(class4.spawners.age.mean.fish) = c("year","age_0","age_1","age_2","age_3","age_4","age_5")
      
      ##class4.spawners.length.mean.fish
      start.class4.spawners.length.mean.fish.row = finish.class4.spawners.age.mean.fish.row+3;
      finish.class4.spawners.length.mean.fish.row = start.class4.spawners.length.mean.fish.row+no.years-1;
      class4.spawners.length.mean.fish = out.dat[c(start.class4.spawners.length.mean.fish.row:finish.class4.spawners.length.mean.fish.row),1]
      class4.spawners.length.mean.fish = sapply(strsplit(class4.spawners.length.mean.fish,"\t"),as.numeric)
      class4.spawners.length.mean.fish = data.frame(t(class4.spawners.length.mean.fish))
      colnames(class4.spawners.length.mean.fish) = c("year","age_0","age_1","age_2","age_3","age_4","age_5")
      
      ##sim.var.used
      start.sim.var.used.row = finish.class4.spawners.length.mean.fish.row+3;
      finish.sim.var.used.row = start.sim.var.used.row+no.years-1;
      sim.var.used = out.dat[c(start.sim.var.used.row:finish.sim.var.used.row),1]
      sim.var.used = sapply(strsplit(sim.var.used,"\t"),as.numeric)
      sim.var.used = data.frame(t(sim.var.used))
      colnames(sim.var.used) = c("year","sum_temp","twin_temp","egg_mort","smolt_survival")
      
      ################################################################################
      ##outallele
      ################################################################################
      #variables and loci are the same as those stored in out.raw - check this!
      
      #embryonic allele frequencies
      start.embryonic.allele.freq.row = 31+no.loci+2;
      end.embryonic.allele.freq.row = start.embryonic.allele.freq.row+no.years-1;
      embryonic.allele.freq = outallele.dat[c(start.embryonic.allele.freq.row:end.embryonic.allele.freq.row),1]
      embryonic.allele.freq = sapply(strsplit(embryonic.allele.freq,"\t"),as.numeric);
      embryonic.allele.freq = data.frame(t(embryonic.allele.freq))
      colnames(embryonic.allele.freq) = sapply(strsplit(outallele.dat[start.embryonic.allele.freq.row-1,1],"\t"),as.character)
      
      #freshwater allele frequencies
      start.freshwater.allele.freq.row = end.embryonic.allele.freq.row+3;
      end.freshwater.allele.freq.row = start.freshwater.allele.freq.row+no.years-1;
      freshwater.allele.freq = outallele.dat[c(start.freshwater.allele.freq.row:end.freshwater.allele.freq.row),1]
      freshwater.allele.freq = sapply(strsplit(freshwater.allele.freq,"\t"),as.numeric);
      freshwater.allele.freq = data.frame(t(freshwater.allele.freq))
      colnames(freshwater.allele.freq) = sapply(strsplit(outallele.dat[start.freshwater.allele.freq.row-1,1],"\t"),as.character)
      
      #marine allele frequencies
      start.marine.allele.freq.row = end.freshwater.allele.freq.row+3;
      end.marine.allele.freq.row = start.marine.allele.freq.row+no.years-1;
      marine.allele.freq = outallele.dat[c(start.marine.allele.freq.row:end.marine.allele.freq.row),1]
      marine.allele.freq = sapply(strsplit(marine.allele.freq,"\t"),as.numeric);
      marine.allele.freq = data.frame(t(marine.allele.freq))
      colnames(marine.allele.freq) = sapply(strsplit(outallele.dat[start.marine.allele.freq.row-1,1],"\t"),as.character)
      
      #female spawner lifetime reproductive success
      start.female.spawner.lifetime.repro.success.row = end.marine.allele.freq.row+4;
      end.female.spawner.lifetime.repro.success.row = start.female.spawner.lifetime.repro.success.row+no.years-1;
      female.spawner.lifetime.repro.success = outallele.dat[c(start.female.spawner.lifetime.repro.success.row:end.female.spawner.lifetime.repro.success.row),1]
      female.spawner.lifetime.repro.success = sapply(strsplit(female.spawner.lifetime.repro.success,"\t"),as.numeric);
      female.spawner.lifetime.repro.success = data.frame(t(female.spawner.lifetime.repro.success))
      colnames(female.spawner.lifetime.repro.success) = c("year","wild_mean","wild_stdev","intro_mean","intro_stdev")
      
      #differentials
      start.differentials.row = end.female.spawner.lifetime.repro.success.row+3;
      end.differentials.row = start.differentials.row+no.years-1;
      differentials = outallele.dat[c(start.differentials.row:end.differentials.row),1]
      differentials = sapply(strsplit(differentials,"\t"),as.numeric);
      differentials = data.frame(t(differentials))
      colnames(differentials) = sapply(strsplit(outallele.dat[start.differentials.row-1,1],"\t"),as.character)
      
      #Calculations for fitness differentials
      embryonic.calculations = embryonic.allele.freq[,seq(3,22,by=2)]*t(loci.effects[,2])
      freshwater.calculations = freshwater.allele.freq[,seq(3,22,by=2)]*t(loci.effects[,2])
      marine.calculations = marine.allele.freq[,seq(3,22,by=2)]*t(loci.effects[,2])
      
      embryonic.calculations = apply(embryonic.calculations,1,sum)
      freshwater.calculations = apply(freshwater.calculations,1,sum)
      marine.calculations = apply(marine.calculations,1,sum)
      
      embryonic.calculations = -0.01*embryonic.calculations + 1
      freshwater.calculations = -0.01*freshwater.calculations + 1
      marine.calculations = -0.01*marine.calculations + 1
      
      embryonic.fitness.diff = 1 - embryonic.calculations
      freshwater.fitness.diff = 1 - freshwater.calculations
      marine.fitness.diff = 1 - marine.calculations
      
      ####plotting.
      ### printing text for title and outputting variable values
      pdf(plot_file,paper="a4",width=10,height=15)
      par(oma=c(0,0,0,0),mar=c(0,0,0,0),cex=1.8)
      plot(1,xlim=c(0,100),ylim=c(0,100),xlab="",ylab="",type="n",axes=FALSE)
      text(50,90,"Output Plots from GIFPSalmon Program")
      
      #sorting out what to plot - only plotting those things that differ from the defaults.
      if(no.sims.default==no.sims){
        printing.variables[1] = ""
      }
      if(no.years.default==no.years){
        printing.variables[2] = ""
      }
      if(start.non.native.after.year.default==start.non.native.after.year){
        printing.variables[3] = ""
      }
      if(stop.non.native.after.year.default==stop.non.native.after.year){
        printing.variables[4] = ""
      }
      if(yearly.inputs.default==yearly.inputs){
        printing.variables[c(5,6,7)] = ""
      }
      if(large.scale.inputs.default==large.scale.inputs){
        printing.variables[c(8,9,10,11)] = ""
      }
      if(non.native.mf.ratio.default==non.native.mf.ratio){
        printing.variables[12] = ""
      }
      if(habitat.size.default==habitat.size){
        printing.variables[13] = ""
      }
      if(no.loci.default==no.loci){
        printing.variables[14] = ""
      }
      if(loci.dist.default==loci.dist){
        printing.variables[15] = ""
      }
      if(selection.default==selection){
        printing.variables[16] = ""
      }
      printing.variables = printing.variables[-which(printing.variables=="")]
      #plotting text  
      spacing = 3.25
      par(oma=c(0,0,0,0),mar=c(0,0,0,0),cex=1.8)
      plot(1,xlim=c(0,100),ylim=c(0,100),xlab="",ylab="",type="n",axes=FALSE)
      text(10,90,"Input Variables altered from Default Values",adj=c(0,0))
      par(cex=1.2)
      num_lines = length(printing.variables)
      if(num_lines==1){
        if(length(grep("Population crash:",printing.variables[1]))==0) {
          for(i in c(1:(num_lines-1))){
            text(10,85-i*spacing,printing.variables[i],adj=c(0,0))  
          }
        }
      }else{
        for(i in c(1:(num_lines-1))){
          text(10,85-i*spacing,printing.variables[i],adj=c(0,0))  
        }
      }  
      printing.variables[num_lines] = sub("[.]",",",printing.variables[num_lines])
      printing.variables.split = strsplit(printing.variables[num_lines],", ");
      
      if(pop.crash=="On"){  #check if anything else has changed
        print_vec = c();
        if(pop.crash.start.year.default != pop.crash.start.year){
          print_vec = c(1,2);
        }
        if(pop.crash.fish.stage.default != pop.crash.fish.stage){
          print_vec = c(print_vec,c(1,3));
        }
        if(pop.crash.mort.prop.default != pop.crash.mort.prop){
          print_vec = c(print_vec,c(1,4));
        }
        print_vec = unique(print_vec)
        for(j in print_vec){
          text(10,85-num_lines*spacing-(j-1)*spacing,printing.variables.split[[1]][j],adj=c(0,0))
        }
      }else{
        text(10,85-num_lines*spacing,printing.variables.split[[1]][1],adj=c(0,0))    #printing no to show we did actually check it
      }
      
      ##plotting graphs
      par(oma=c(0,0,0,0),mar=c(4,4,4,7),xpd=TRUE,mfrow=c(3,1),lwd=1.5)
      ###Embryonic allele frequencies
      plot(1,xlim=c(0,no.years),ylim=c(0,1),type="n",main="Embryonic allele frequencies",xlab="Model Year",ylab="Allele frequency")
      colours = rainbow(ncol(embryonic.allele.freq)-3)
      for(i in c(3:ncol(embryonic.allele.freq))){lines(embryonic.allele.freq[,i],col=colours[i])}
      legend_names = colnames(embryonic.allele.freq)[3:ncol(embryonic.allele.freq)]
      legend(no.years*1.075,1.05,legend_names,lty=rep(1,length.out=ncol(embryonic.allele.freq)-3),col=colours)
      
      ###Freshwater allele frequencies
      plot(1,xlim=c(0,no.years),ylim=c(0,1),type="n",main="Freshwater allele frequencies",xlab="Model Year",ylab="Allele frequency")
      colours = rainbow(ncol(freshwater.allele.freq)-3)
      for(i in c(3:ncol(freshwater.allele.freq))){lines(freshwater.allele.freq[,i],col=colours[i])}
      legend_names = colnames(freshwater.allele.freq)[3:ncol(freshwater.allele.freq)]
      legend(no.years*1.075,1.05,legend_names,lty=rep(1,length.out=ncol(freshwater.allele.freq)-3),col=colours)
      
      ###Marine allele frequencies
      plot(1,xlim=c(0,no.years),ylim=c(0,1),type="n",main="Marine allele frequencies",xlab="Model Year",ylab="Allele frequency")
      colours = rainbow(ncol(marine.allele.freq)-3)
      for(i in c(3:ncol(marine.allele.freq))){lines(marine.allele.freq[,i],col=colours[i])}
      legend_names = colnames(marine.allele.freq)[3:ncol(marine.allele.freq)]
      legend(no.years*1.075,1.05,legend_names,lty=rep(1,length.out=ncol(marine.allele.freq)-3),col=colours)
      
      par(oma=c(0,0,0,0),mar=c(4,4,4,11),xpd=TRUE,mfrow=c(2,1),lwd=1.5)
      ###Reproductive Success
      plot(1,xlim=c(0,no.years),ylim=c(0,max(female.spawner.lifetime.repro.success[,c(2,4)])),type="n",main="Lifetime reproductive success",xlab="Model Year",ylab="Reproductive success")
      colours = c("darkblue","deeppink","black")
      lines(female.spawner.lifetime.repro.success[,2],col=colours[1])
      lines(female.spawner.lifetime.repro.success[,4],col=colours[2])
      abline(lm(female.spawner.lifetime.repro.success$wild_mean~female.spawner.lifetime.repro.success$year),xpd=FALSE,col=colours[3])
      legend_names = c("Wild/Hybrid","Farmed","Linear Wild/Hybrid")
      legend(no.years*1.075,max(female.spawner.lifetime.repro.success[,c(2,4)]),legend_names,lty=rep(1,length.out=3),col=colours)
      
      ###Fitness Differential
      plot(1,xlim=c(0,no.years),ylim=c(min(embryonic.fitness.diff,freshwater.fitness.diff,marine.fitness.diff),max(embryonic.fitness.diff,freshwater.fitness.diff,marine.fitness.diff)),type="n",main="Fitness Differential",xlab="Model Year",ylab="Fitness Differential")
      colours = c("gold","darkblue","deeppink")
      lines(embryonic.fitness.diff,col=colours[1])
      lines(freshwater.fitness.diff,col=colours[2])
      lines(marine.fitness.diff,col=colours[3])
      legend_names = c("Embryonic","Fitness","Marine")
      legend(no.years*1.075,max(embryonic.fitness.diff,freshwater.fitness.diff,marine.fitness.diff),legend_names,lty=rep(1,length.out=3),col=colours)
      
      par(oma=c(0,0,0,0),mar=c(4,6,4,7),xpd=TRUE,mfrow=c(2,1),lwd=1.5,las=1)
      ###Numbers - log scale
      plot(1,log="y",xlim=c(0,no.years),ylim=c(1,max(class.number)),type="n",main="Fish Numbers",xlab="Model Year",ylab="",yaxt="n")
      colours = rainbow(4)
      lines(class.number$eggs,col=colours[1])
      lines(class.number$parr,col=colours[2])
      lines(class.number$smolts,col=colours[3])
      lines(class.number$spawn,col=colours[4])
      legend_names = c("Eggs","Parr","Smolts","Spawn")
      legend(no.years*1.075,max(class.number),legend_names,lty=rep(1,length.out=4),col=colours)
      options("scipen"=100)
      axis(2,c(10^(0:ceiling(log10(max(class.number))))))
      mtext("Numbers",2,5,las=0)
      
      par(oma=c(0,0,0,0),mar=c(4,4,4,10),xpd=TRUE,mfrow=c(2,1),lwd=1.5,las=1)
      ###Numbers - Spawners and Inputs
      if(length(class.number$spawn)>length(nonnative.inputs$spawn)){
        length_diff = length(class.number$spawn)-length(nonnative.inputs$spawn)
        nonnative.inputs.spawn = c(rep(0,length.out=length_diff),nonnative.inputs$spawn)
        plot(1,xlim=c(0,no.years),ylim=c(1,max(class.number$spawn)),type="n",main="Spawners",xlab="Model Year",ylab="Number",yaxt="n")
        colours = rainbow(2)
        lines(class.number$spawn,col=colours[1])
        lines(class.number$spawn-nonnative.inputs.spawn,col=colours[2])
        legend_names = c("Spawn","Spawn - Inputs")
        legend(no.years*1.075,max(class.number$spawn),legend_names,lty=rep(1,length.out=2),col=colours)
      }else if(length(nonnative.inputs$spawn)>length(class.number$spawn)){
        length_diff = length(nonnative.inputs$spawn)-length(class.number$spawn)
        class.number.spawn = c(rep(0,length.out=length_diff),class.number.spawn)
        plot(1,xlim=c(0,no.years),ylim=c(1,max(class.number$spawn)),type="n",main="Spawners",xlab="Model Year",ylab="Number",yaxt="n")
        colours = rainbow(2)
        lines(class.number.spawn,col=colours[1])
        lines(class.number.spawn-nonnative.inputs$spawn,col=colours[2])
        legend_names = c("Spawn","Spawn - Inputs")
        legend(no.years*1.075,max(class.number$spawn),legend_names,lty=rep(1,length.out=2),col=colours)
      }else{
        plot(1,xlim=c(0,no.years),ylim=c(1,max(class.number$spawn)),type="n",main="Spawners",xlab="Model Year",ylab="Number",yaxt="n")
        colours = rainbow(2)
        lines(class.number$spawn,col=colours[1])
        lines(class.number$spawn-nonnative.inputs$spawn,col=colours[2])
        legend_names = c("Spawn","Spawn - Inputs")
        legend(no.years*1.075,max(class.number),legend_names,lty=rep(1,length.out=2),col=colours)
      }
      axis(2)
      
      ##inputs
      plot(1,xlim=c(0,no.years),ylim=c(1,max(nonnative.inputs$spawn)),type="n",main="Inputs",xlab="Model Year",ylab="Number",yaxt="n")
      colours = rainbow(1)
      lines(nonnative.inputs$spawn,col=colours[1])
      legend_names = c("Inputs")
      legend(no.years*1.075,max(nonnative.inputs$spawn),legend_names,lty=rep(1,length.out=2),col=colours)
      axis(2)
      
      ###Fish ages
      ###parr
      #proportion
      par(oma=c(0,0,0,0),mar=c(4,4,5,7),xpd=TRUE,mfrow=c(2,1),lwd=1.5)
      plot(1,xlim=c(0,no.years),ylim=c(0,100),type="n",main="Parr Proportion at Age (years)",xlab="Model Year",ylab="Percentage")
      colours = rainbow(ncol(class1.parr.age.mean.fish)-1)
      for(i in c(2:ncol(class1.parr.age.mean.fish))){
        lines((class1.parr.age.mean.fish[,i]/apply(class1.parr.age.mean.fish,1,sum))*100,col=colours[i])
      }
      legend_names = c("Age 0","Age 1","Age 2","Age 3","Age 4","Age 5","Age 6","Age 7","Age 8","Age 9")
      legend(no.years*1.075,100,legend_names,lty=rep(1,length.out=length(colours)),col=colours)
      
      #mean ages
      par(mar=c(3,4,3,11))
      mean.age.parr = apply(class1.parr.age.mean.fish[,c(2:11)],1,
                            function(x){
                              if(sum(x) == 0){
                                return(sum(x)); #to cover the case that there are no fish of any age
                              }else{
                                return(sum(x*c(0:9))/sum(x));
                              }
                            })
      plot(1,xlim=c(0,no.years),ylim=c(floor(min(mean.age.parr)),ceiling(max(mean.age.parr))),type="n",main="Mean Parr Age (years)",xlab="Model Year",ylab="Mean Age")
      colours = c("red","black")
      lines(mean.age.parr,col=colours[1])
      abline(lm(mean.age.parr~c(1:no.years)),xpd=FALSE,col=colours[2])
      legend_names = c("Mean Age", "Linear mean age")
      legend(no.years*1.075,ceiling(max(mean.age.parr)),legend_names,lty=rep(1,length.out=length(colours)),col=colours)
      
      ###smolt
      #proportion
      par(oma=c(0,0,0,0),mar=c(4,4,5,7),xpd=TRUE,mfrow=c(2,1),lwd=1.5)
      plot(1,xlim=c(0,no.years),ylim=c(0,100),type="n",main="Smolts Proportion at Age (years)",xlab="Model Year",ylab="Percentage")
      colours = rainbow(ncol(class2.smolts.age.mean.fish)-1)
      for(i in c(2:ncol(class2.smolts.age.mean.fish))){
        lines((class2.smolts.age.mean.fish[,i]/apply(class2.smolts.age.mean.fish,1,sum))*100,col=colours[i])
      }
      legend_names = c("Age 0","Age 1","Age 2","Age 3","Age 4","Age 5","Age 6","Age 7","Age 8","Age 9")
      legend(no.years*1.075,100,legend_names,lty=rep(1,length.out=length(colours)),col=colours)
      
      #mean ages
      par(mar=c(3,4,3,11))
      mean.age.smolts = apply(class2.smolts.age.mean.fish[,c(2:11)],1,
                              function(x){
                                if(sum(x) == 0){
                                  return(sum(x)); #to cover the case that there are no fish of any age
                                }else{
                                  return(sum(x*c(0:9))/sum(x));
                                }
                              })
      plot(1,xlim=c(0,no.years),ylim=c(floor(min(mean.age.smolts)),ceiling(max(mean.age.smolts))),type="n",main="Mean Smolts Age (years)",xlab="Model Year",ylab="Mean Age")
      colours = c("red","black")
      lines(mean.age.smolts,col=colours[1])
      abline(lm(mean.age.smolts~c(1:no.years)),xpd=FALSE,col=colours[2])
      legend_names = c("Mean Age", "Linear mean age")
      legend(no.years*1.075,ceiling(max(mean.age.smolts)),legend_names,lty=rep(1,length.out=length(colours)),col=colours)
      
      ###spawn
      #proportion
      par(oma=c(0,0,0,0),mar=c(4,4,5,7),xpd=TRUE,mfrow=c(2,1),lwd=1.5)
      plot(1,xlim=c(0,no.years),ylim=c(0,100),type="n",main="Spawners Proportion at Age (years)",xlab="Model Year",ylab="Percentage")
      colours = rainbow(ncol(class4.spawners.age.mean.fish)-1)
      for(i in c(2:ncol(class4.spawners.age.mean.fish))){
        lines((class4.spawners.age.mean.fish[,i]/apply(class4.spawners.age.mean.fish,1,sum))*100,col=colours[i])
      }
      legend_names = c("Age 0","Age 1","Age 2","Age 3","Age 4","Age 5")
      legend(no.years*1.075,100,legend_names,lty=rep(1,length.out=length(colours)),col=colours)
      
      #mean ages
      par(mar=c(3,4,3,11))
      mean.age.spawners = apply(class4.spawners.age.mean.fish[,c(2:7)],1,
                                function(x){
                                  if(sum(x) == 0){
                                    return(sum(x))  
                                  }else{
                                    return(sum(x*c(0:5))/sum(x))
                                  }
                                });
      plot(1,xlim=c(0,no.years),ylim=c(floor(min(mean.age.spawners)),ceiling(max(mean.age.spawners))),type="n",main="Mean Spawners Age (years)",xlab="Model Year",ylab="Mean Age")
      colours = c("red","black")
      lines(mean.age.spawners,col=colours[1])
      abline(lm(mean.age.spawners~c(1:no.years)),xpd=FALSE,col=colours[2])
      legend_names = c("Mean Age", "Linear mean age")
      legend(no.years*1.075,ceiling(max(mean.age.spawners)),legend_names,lty=rep(1,length.out=length(colours)),col=colours)
      
      ###Fish sizes
      ###parr
      #proportion
      par(oma=c(0,0,0,0),mar=c(4,4,5,8),xpd=TRUE,mfrow=c(3,1),lwd=1.5)
      plot(1,xlim=c(0,no.years),ylim=c(0,max(class1.parr.length.mean.fish[,c(2:ncol(class1.parr.length.mean.fish))])),type="n",main="Parr Mean Length at Age (years)",xlab="Model Year",ylab="Length(mm)")
      colours = rainbow(ncol(class1.parr.length.mean.fish)-1)
      for(i in c(2:ncol(class1.parr.length.mean.fish))){
        lines(class1.parr.length.mean.fish[,i],col=colours[i])
      }
      legend_names = c("Age 0","Age 1","Age 2","Age 3","Age 4","Age 5","Age 6","Age 7","Age 8","Age 9")
      legend(no.years*1.075,max(class1.parr.length.mean.fish[,c(2:ncol(class1.parr.length.mean.fish))]),legend_names,lty=rep(1,length.out=length(colours)),col=colours)
      
      ###smolt
      plot(1,xlim=c(0,no.years),ylim=c(0,max(class2.smolts.length.mean.fish[,c(2:ncol(class2.smolts.length.mean.fish))])),type="n",main="Smolts Mean Length at Age (years)",xlab="Model Year",ylab="Length(mm)")
      colours = rainbow(ncol(class2.smolts.length.mean.fish)-1)
      for(i in c(2:ncol(class2.smolts.length.mean.fish))){
        lines(class2.smolts.length.mean.fish[,i],col=colours[i])
      }
      legend_names = c("Age 0","Age 1","Age 2","Age 3","Age 4","Age 5","Age 6","Age 7","Age 8","Age 9")
      legend(no.years*1.075,max(class2.smolts.length.mean.fish[,c(2:ncol(class2.smolts.length.mean.fish))]),legend_names,lty=rep(1,length.out=length(colours)),col=colours)
      
      ###spawn
      plot(1,xlim=c(0,no.years),ylim=c(0,max(class4.spawners.length.mean.fish[,c(2:ncol(class4.spawners.length.mean.fish))])),type="n",main="Spawners Mean Length at Age (years)",xlab="Model Year",ylab="Length(mm)")
      colours = rainbow(ncol(class4.spawners.length.mean.fish)-1)
      for(i in c(2:ncol(class4.spawners.length.mean.fish))){
        lines(class4.spawners.length.mean.fish[,i],col=colours[i])
      }
      legend_names = c("Age 0","Age 1","Age 2","Age 3","Age 4","Age 5")
      legend(no.years*1.075,max(class4.spawners.length.mean.fish[,c(2:ncol(class4.spawners.length.mean.fish))]),legend_names,lty=rep(1,length.out=length(colours)),col=colours)
      
      invisible(dev.off())
    }
  )
  
  output$Altered_vars = renderTable({
    
    GIFPSalmon()
    
    
  })
})
