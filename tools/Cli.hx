

import haxe.io.Path;
import Sys;
import neko.Lib;

import sys.FileSystem;
import sys.io.File;
import StringTools;
using StringTools;
class Cli {
	
	static var firmamentPath:String;
	static var projectHomeDir:String;
	public static function main() {
		var args:Array<String> = Sys.args();
		var last:String = (new haxe.io.Path(args.pop())).toString();
		var slash = last.substr( -1);

	
		firmamentPath = Sys.getCwd();
		
		if (slash=="/"|| slash=="\\") 
			last = last.substr(0,last.length-1);
		if (FileSystem.exists(last) && FileSystem.isDirectory(last)) {
			Sys.setCwd(last);
		}
		
		
		if (args.length == 0) {
				Lib.println("possible commands: 
	setup [project name] [?package name?] [?template?]  -  Sets up a new project
	edit [?project file?]  -  opens the editor for the project");
				return;
		}
		
		switch(args[0]) {
			case "setup": {
				if (args.length < 2) {
					Lib.println("setup requires project name.");
					return;
				}
				if(args.length == 4){
					doSetup(args[1],args[2],args[3]);
				} else if(args.length == 3){
					doSetup(args[1],args[2]);
				}else {
					doSetup(args[1]);
				}
			}
			case "edit":{
				Sys.putEnv("FirmamentEditorPath",firmamentPath);
				Sys.putEnv("FirmamentEditorCWD",Sys.getCwd());
				if(args.length <2)
					Sys.command("neko", [firmamentPath+"/FirmamentEditor.n"]);
				else 
					Sys.command("neko", [firmamentPath+"/FirmamentEditor.n",args[1]]);

			}
		}
		
		
		
		
	}
	
	static function doSetup(projectName:String, ?packageName:String = "com.firmamentengine.example", ?template:String = "SimpleProject") {
		projectName = ucFirst(projectName);
		Lib.println("Creating new project...");
		if (FileSystem.exists(projectName)) {
			Lib.println("Directory '" + projectName + "' already exists.");
			return;
		}
		
		var templatePath = firmamentPath + "/templates/" + template;
		if (!FileSystem.exists(templatePath)) {
			Lib.println("Template '"+template+"' cannot be found. (looking in " + templatePath + ")");
			return;
		}
		
		Lib.println("Creating project '"+projectName+"' ...");
		
		var vars:Dynamic = { 
			PROJECT_NAME:projectName
			,PACKAGE_NAME:packageName
		
		};

		var sourceCodeDir =  "src/" + packageName.replace(".", "/");
		vars.SOURCE_CODE_DIR = sourceCodeDir;

		projectHomeDir = Sys.getCwd()+projectName;

		processTemplateDir(templatePath, projectName,vars,projectName,"__SRC__");
		
		sourceCodeDir = projectName +"/"+sourceCodeDir;
		makeDirRecursive(sourceCodeDir);
		processTemplateDir(templatePath+"/__SRC__", sourceCodeDir,vars,projectName);
			
			
		
		Lib.println("Project '" + projectName + "' Created! Run the following to try it out:");
		Lib.println("cd " + projectName);
		Lib.println("nme test "+projectName+".nmml flash");
		Lib.println("----------------------------------------");

		Lib.println("To run the editor, run: haxelib run firmament edit");
	}
	
	static function makeDirRecursive(path:String) {
		var dirs = path.split("/");
		var workingPath = "";
		for (dir in dirs) {
			if (workingPath != '') dir = workingPath + '/' + dir;
			if (!FileSystem.exists(dir)) {
				FileSystem.createDirectory(dir);
			}
			workingPath = dir;
			
		}
	}
	
	static function processTemplateDir(srcDir:String, destDir:String, vars:Dynamic, projectName:String,?skipDir:String='') {
		if (!FileSystem.isDirectory(srcDir)) {
			Lib.println(srcDir + " is not a directory!");
			return;
		}
		if (!FileSystem.exists(destDir)) {
			FileSystem.createDirectory(destDir);
		}
		
		
		
		var entries = FileSystem.readDirectory(srcDir);
		
		for (entry in entries) {
			var sdir = srcDir + "/" + entry;
			if (FileSystem.isDirectory(sdir)) {
				
				//only process if we aren't in our skip directory.
				if (skipDir == '' || sdir.indexOf(skipDir) == -1) {
					processTemplateDir(sdir, destDir+'/'+entry, vars, projectName, skipDir);
				}
			}
			else {
				smartCopy(entry,srcDir, destDir , vars, projectName);
			}
		}
		
		
	}
	
	static function smartCopy(fileName:String,srcDir:String, destDir:String, vars:Dynamic, projectName:String) {
		var data = File.getContent(srcDir+"/"+fileName);
		
		var destFile = fileName.replace("__PROJECT_NAME__", projectName);
		
		//do interpolation if the filename is any of these types
		if (stringContainsAny(fileName, [".hx", ".nmml", ".xml", ".md", ".htm", ".html", ".txt",".fprj",".sublime"])){
			data = interpolateVarsIntoString(data, vars);
		}
		File.saveContent(destDir + "/" + destFile,data);
			
	}
	
	static function interpolateVarsIntoString(str:String, vars:Dynamic):String {
		vars.HAXE_PATH = Sys.getEnv("HAXEPATH");
		vars.FIRMAMENT_PATH = firmamentPath.replace("\\","/");
		vars.PROJECT_HOME_PATH = projectHomeDir.replace("\\","/");
		//no colon varieties
		vars.PROJECT_HOME_PATH_NC = projectHomeDir.replace("\\","/").replace(":","");
		vars.FIRMAMENT_PATH_NC = firmamentPath.replace("\\","/").replace(":","");
		var fields = Reflect.fields(vars);
		for (field in fields) {
			str=str.replace("[*" + field + "*]", Reflect.field(vars, field));
		}
		return str;
	}
	
	static function stringContainsAny(str:String, substrs:Array<String>) {
		for (substr in substrs) {
			if (str.indexOf(substr) != -1) return true;
		}
		return false;
	}
	
	static function ucFirst(str:String) {
		var first = str.charAt(0);
		first = first.toUpperCase();
		return first + str.substr(1);
	}


	
}