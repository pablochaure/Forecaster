from gluonts.model.deepar._estimator import DeepAREstimator as DAREst
from gluonts.dataset.util import to_pandas
from gluonts.model import n_beats
from gluonts.dataset.common import ListDataset
import pandas as pd
import matplotlib.pyplot as pplt
from pathlib import Path
from gluonts.model.predictor import Predictor
from gluonts.mx.trainer._base import Trainer
import scipy.stats
import numpy as np
import sys
import os
import sklearn
import time
# from ray import tune
class DLTSForecast:
    def __init__(self,
            ##Required
                 df,
                 modelName=None,

    ##Options
                 saveModel=0,
                 loadModel=0,
                 dateColName=None,
                 priceColName=None,
                 pdFreq=None,
                 futureLen=None,
                 backcastLen=None,
                 p1=None,


    ##Trainer
        ##Network Parameters
                 nEpochs=None,                                                                                          #TODO: Should I change depending on model? Move elsewhere?
                 batchSize=32,
                 batchPEpoch=50,
        ##Gradient Update Parameters
                 lr=None,
                 lrDecayFactor=None,
                 lrMin=None,
                 patience=None,
                 clipGradient=None,
                 weightDecay=None,
    ##Other
                 init=None,
                 hybridize=None,
                 postInitializeCB=None,

                 dropoutRate=None,
                 nTrials=None,
                 lossFunc=None,
                 expansionCoeffLen=None,
                 baggingSize=None
                 ): #TODO



        self.saveModel = saveModel
        self.loadModel=loadModel


        if df is None:
            raise Exception('Give me data')
        else:
            self.df = df

        if modelName is not None:
            self.modelName = modelName
        else:
            self.modelName = 'DeepAR'

        if dateColName is not None:
            self.dateColName = dateColName
        else:
            self.dateColName = "Date"

        if priceColName is not None:
            self.priceColName = priceColName
        else:
            self.priceColName = "Value"

        if pdFreq is not None:
            if pdFreq == 'yearly':
                self.pdFreq = 'Y'
            if pdFreq == 'quarterly':
                self.pdFreq = 'Q'
            if pdFreq == 'monthly':
                self.pdFreq = 'M'
            if pdFreq == 'weekly':
                self.pdFreq = 'W'
            if pdFreq == 'daily':
                self.pdFreq = 'D'
            if pdFreq == 'hourly':
                self.pdFreq = 'H'
            if pdFreq == 'minute':
                self.pdFreq = 'T'
            else:
                self.pdFreq=pdFreq

        else:
            self.pdFreq=pd.infer_freq(self.df[self.dateColName])


        if futureLen is not None:
            self.futureLen=futureLen
        else:
            self.futureLen=len(self.df)*0.2-1

        if nEpochs is not None:
            self.nEpochs=nEpochs
        else:
            self.nEpochs=2                      #TODO: Find best epochs for losses

        if (backcastLen is not None):
            if (backcastLen<=(len(self.df)-self.futureLen)):
                self.backcastLen=backcastLen
            if (backcastLen>(len(self.df)-self.futureLen)):
                raise Exception ('Out of frame and cannot validate: backcast length + prediction length exceeds data length.')
        elif (len(self.df)>3*self.futureLen):
            self.backcastLen=2*futureLen
        else:
            raise Exception('Too short')

        if nTrials is not None:
            self.nTrials=nTrials
        else:
            self.nTrials=1

# These already have default values when using in NBeatsEnsemble
        if lr is not None:
            self.lr=lr

        if lossFunc is not None:
            self.lossFunc = lossFunc

        if expansionCoeffLen is not None:
            self.expansionCoeffLen = expansionCoeffLen

        if baggingSize is not None:
            self.baggingSize=baggingSize

        if p1 is not None:
            self.p1=p1

# Convert dataframe to ListDataset to dump into estimator
    def df2LDS(self, dataframe=None, start=0):      #Should I change inputs to something else?
        if dataframe is None:
            dataframe=self.df[:-self.futureLen]
        # dataframe=dataframe[[self.dateColName,self.priceColName]]
        data=ListDataset(
            [{"start":dataframe.iloc[:,0][start],              #[0] should change if Vdata
            "target":dataframe.iloc[:,1]}],
            freq=self.pdFreq)
        return data


# DeepAR estimator generator (Only skeleton)
    def createDAREstimator(self):
        trainer=Trainer(epochs=self.nEpochs)                                                                            #TODO: Optimize parameters
        model=DAREst(self.pdFreq,
                                self.futureLen,
                                trainer=trainer,
                                context_length=self.backcastLen,
                                dropout_rate=0.1)                                                                       #TODO: Make it an input?
        return model

# NBeats estimator generator (Only skeleton)
    def createNBeatsEnsembleEstimator(self):
        trainer = Trainer(epochs=self.nEpochs
                          )

        model = n_beats.NBEATSEnsembleEstimator(freq=self.pdFreq,
                                                prediction_length=self.futureLen,
                                                meta_loss_function=self.lossFunc,#['sMAPE', 'MASE', 'MAPE'],
                                                meta_bagging_size=self.baggingSize,
                                                meta_context_length=list(self.backcastLen),
                                                expansion_coefficient_lengths=[3],
                                                trainer=trainer)

        return model


# Train model with new inputs (Complete the estimator which was only skeleton) ANY model could be trained
    def trainEstimator(self, estimator, trainingData=None):
        if trainingData is None:  # Default value for trainingData
            trainingData = self.df[:-self.futureLen]
        trainingData = self.df2LDS(trainingData)  # Convert trainingData to usable ListDataSet

        trained = estimator.train(
            training_data=trainingData)
        return trained

    # Load estimator
    def loadEst(self,path=None):
        if path is None:
            path = Path(r'.\params2')                                                                                   # Default path for estimator to load
            #folderPath=input('Where is the estimator stored?')
        else:
            path=path
        predictor = Predictor.deserialize(path)
        return predictor

# Save estimator
    def saveEst(self,predictor,path=None):
        if path is None:
            path=Path(r'.\params2')                                                                                     # TODO:Default path for saving estimator/Or Ask?
            #folderPath=input('Creating new folder. Give me a name')
            #os.makedirs('my_folder')
        else:
            path = path
        predictor.serialize(path)


# Plotter
    def plotPreds(self,future):
        plot_length=len(self.df)
        prediction_intervals = (50.0, 90.0)
        self.df.plot.line(self.dateColName,self.priceColName)                                            #Plot line graph: Plotted line is median, not mean
        future.plot(prediction_intervals=prediction_intervals,
                            color='g')                                                                                  #Plot predicted. input type:sampleforecast

# Get 2sided CI (median+-45 for 90, +-5 for 10)
    def getStdev(self,sampleForecast,zVal=None):                                                                        #0<zVal<=100
        #From the median
        if zVal is None:
            zVal=90
        zSigma1=sampleForecast.quantile(zVal/100/2)
        zSigma2=sampleForecast.quantile(0.5-zVal/100/2)
        return zSigma1, zSigma2


    def sample(self):
        # # Instantiate object. to call from outside: from test import DLTSForecast \n DLTSForecast(----)


        # Preprocess

        trainingData = self.df[:-self.futureLen]
        trainingDataLDS = self.df2LDS(trainingData)

        # Create/train model and validate
        if self.modelName == 'DeepAR':
            estimator = self.createDAREstimator()
        elif self.modelName == 'NBeats Ensemble':
            estimator=self.createNBeatsEnsembleEstimator()

        if self.loadModel == 0:
            trainedEstimator = self.trainEstimator(estimator=estimator)
            if self.saveModel != 0:
                self.saveEst(trainedEstimator)                                                                          # Save model
        if self.loadModel != 0:
            trainedEstimator=self.loadEst()                                                                             # Load model

        prediction = trainedEstimator.predict(trainingDataLDS)  # Still a generator object
        nextpred = next(prediction)
        valMedian=nextpred.median
        # self.plotPreds(nextpred)
        stdev1H, stdev1L = self.getStdev(nextpred, self.p1)

        # Use model above to "see the future"
        allLDS = self.df2LDS(self.df)
        future = trainedEstimator.predict(allLDS)  # Still a generator object
        futureVal = next(future)
        futMedian=futureVal.median
        # self.plotPreds(futureVal)

        stdev2H, stdev2L=self.getStdev(futureVal, self.p1)



        ret=self.df
        ret['Medians']=pd.Series(valMedian)
        ret['StdevHighs']=pd.Series(stdev1H)
        ret['StdevLows']=pd.Series(stdev1L)

        ret['Medians'] = ret['Medians'].shift((self.df.shape[0]-self.futureLen))
        ret['StdevHighs']= ret['StdevHighs'].shift((self.df.shape[0]-self.futureLen))
        ret['StdevLows']= ret['StdevLows'].shift((self.df.shape[0]-self.futureLen))

        rng = pd.date_range(start=ret[self.dateColName].max(), periods=self.futureLen+1, freq=pd.infer_freq(self.df[self.dateColName]))
        myDict=dict()
        myDict[self.dateColName]=rng[1:]
        myDict['Medians']=futMedian
        myDict['StdevHighs']=stdev2H
        myDict['StdevLows']=stdev2L

        df2=pd.DataFrame(myDict)
        # ret.set_index(self.dateColName).combine_first(rng.set_index(self.dateColName)).reset_index()
        ret=ret.append(df2)
        return ret

# TODO


def callDLModels(df,
                 modelName,
                 saveModel=0,
                 loadModel=0,
                 dateColName='Date',
                 priceColName='Value',
                 pdFreq=None,
                 futureLen=16,
                 backcastLen=32,
            ##Trainer##
                 nEpochs=5,
                 batchSize=32,
                 batchPEpoch=50,
                 nTrials=1,
                 expansionCoeffLen=[3],
                 lossFunc=['MAPE'],
                 baggingsize=3,
                 p1=95):

    df=pd.concat([df[dateColName],df[priceColName]],axis=1)
    obj = DLTSForecast(modelName=modelName,
                       df=df,
                       saveModel=saveModel,
                       loadModel=loadModel,
                       dateColName=dateColName,
                       priceColName=priceColName,
                       pdFreq=pdFreq,                                                                                   #TODO: Autodetection has some problems when patterns are weird stuff
                       futureLen=futureLen,
                       nEpochs=nEpochs,  # TODO: Should I change depending on model?
                       backcastLen=backcastLen,
                       nTrials=nTrials,
                       expansionCoeffLen=expansionCoeffLen,
                       lossFunc=lossFunc,
                       baggingSize=baggingsize,
                       p1=p1
                       )

    arr=obj.sample()
    print(arr)
    return arr


# Import csv data
file="m750.csv"
fromCSV=pd.read_csv(file)
fromCSV.iloc[:, 2] = pd.to_datetime(fromCSV.iloc[:, 2])  # String to datetime
callDLModels(fromCSV,'DeepAR',dateColName='date',priceColName='value',pdFreq='M',nEpochs=1)