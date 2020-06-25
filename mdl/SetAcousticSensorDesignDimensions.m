function [SonarWorkbenchElementObj,SonarWorkbenchArrayObj,SonarWorkbenchBeamObj] = SetAcousticSensorDesignDimensions(Ne,Ntype,SonarWorkbenchElementObj,SonarWorkbenchArrayObj,SonarWorkbenchBeamObj)

%% Resize for Number of Different Element Types
if Ntype > 1
    for i=1:length(SonarWorkbenchElementObj.Elements)
        SonarWorkbenchElementObj.Elements(i).Dimensions = [1 Ntype];
    end
    SonarWorkbenchArrayObj.Elements(8).Dimensions = [Ne 1]; % eindex
end
%% Resize for Number of Elements
for i=2:7   % ex, ey, ez, egamma, etheta, epsi
    SonarWorkbenchArrayObj.Elements(i).Dimensions = [Ne 1];
end
SonarWorkbenchBeamObj.Elements(1).Dimensions = [Ne 1];
