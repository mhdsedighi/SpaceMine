function StartupOCL(workingDirLocation)
% Startup script for OpenOCL
% Adds required directories to the path. Sets up a folder for the results
% of tests and a folder for autogenerated code.
% 
% inputs:
%   workingDirLocation - path to location where the working directory 
%                        should be created.

startupDir  = fileparts(which('StartupOCL'));

if isempty(startupDir)
  error('Can not find OpenOCL. Add root directory of OpenOCL to the path.')
end

if nargin == 0
  workingDirLocation = fullfile(startupDir,'..');
end

global testDir
global exportDir

% add current directory to path
addpath(pwd);

% create folders for tests and autogenerated code
testDir     = fullfile(workingDirLocation,'OpenOCL_WorkingDir','test');
exportDir   = fullfile(workingDirLocation,'OpenOCL_WorkingDir','export');
[~,~] = mkdir(testDir);
[~,~] = mkdir(exportDir);

% setup directories
addpath(startupDir)
addpath(exportDir)
addpath(fullfile(startupDir,'CasadiLibrary'))

addpath(fullfile(startupDir,'Core'))
addpath(fullfile(startupDir,'Core','Integrator'))
addpath(fullfile(startupDir,'Core','Expressions'))

% addpath('Interfaces')
addpath(fullfile(startupDir,'Examples'))
addpath(fullfile(startupDir,'Examples','01VanDerPol'))
addpath(fullfile(startupDir,'Examples','02BallAndBeam'))
addpath(fullfile(startupDir,'Examples','03Pendulum'))
addpath(fullfile(startupDir,'Examples','04RaceCar'))
addpath(fullfile(startupDir,'Test'))


% check if casadi is working
try
  casadi.SX.sym('x');
catch e
  if ~strcmp(e.identifier,'MATLAB:undefinedVarOrClass')
    error('Casadi installation in the path found but does not work properly. Try restarting Matlab.');
  else
    error('Casadi installation not found. Please setup casadi 3.2');
  end
end
