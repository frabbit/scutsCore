package scuts;

import haxe.PosInfos;
import haxe.Stack;
import scuts.core.extensions.PosInfosExt;

#if (macro || display)
import haxe.macro.Context;
import haxe.macro.Expr;

using scuts.core.extensions.DynamicExt;
using scuts.core.extensions.PosInfosExt;
#end

class Scuts 
{
  
  public static function id <T> (a:T):T return a
  
  public static function abstractMethod <T>():T 
  {
    return error("This method is abstract, you must override it");
  }
  
  public static function notImplemented <T>(?posInfos:PosInfos):T 
  {
    return error("This method is not yet implemented", posInfos);
  }
  
  public static function unexpected <T>(?posInfos:PosInfos):T 
  {
    return error("This error shoud never occur, please inform the library author to fix this.", posInfos);
  }
  
  public static function checkNotNull <T>(v:T, ?posInfos:PosInfos):T 
  {
    #if debug
    Assert.assertNotNull(v, posInfos);
    #end
    return error("This method is not yet implemented");
  }
  
  public static function error <T>(msg:Dynamic, ?posInfos:PosInfos):T 
  {
    #if macro
    return macroError(Std.string(msg), Context.currentPos(), posInfos);
    #else
    throw msg;
    return null;
    #end
  }
  
  
  #if (macro || display)
  public static function macroError <T>(msg:String, ?p:Position, ?posInfos:PosInfos):T 
  {
    var p1 = p.nullGetOrElseConst(Context.currentPos());
    var stack = Stack.toString(Stack.callStack());
    throw new Error(msg + "\n@" + posInfos.toString() + stack,p1);
    return null;
  }
  
  public static function macroErrors <T>(msg:Array<String>, ?p:Position, ?posInfos:PosInfos):T 
  {
    return macroError(msg.join("\n"), p, posInfos);
  }
  
 
  #end
  
}