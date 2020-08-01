using Fuse;
using Fuse.Scripting;
using Fuse.Reactive;
using Uno.IO;
using Uno.Compiler.ExportTargetInterop;

namespace Bolav.ForeignHelpers {
	public class JSList : ForeignList {
		Context ctx;
		Fuse.Scripting.Array array;
		int pos = 0;

		public JSList (Context c) {
			ctx = c;
			array = (Fuse.Scripting.Array)ctx.Evaluate("(no file)", "new Array()");
		}
		public override ForeignDict NewDictRow () {
			var r = new JSDict(ctx);
			array[pos] = r.GetScriptingObject();
			pos++;
			return r;
		}
		public Fuse.Scripting.Array GetScriptingArray () {
			return array;
		}

		[Foreign(Language.ObjC)]
		extern(iOS) public void FromiOS (ObjC.Object ary)
		@{
			for(id obj in ary) {
			    if ([obj isKindOfClass:[NSDictionary class]]) {
			    	id<UnoObject> ddict = @{JSList:Of(_this).NewDictRow():Call()};
			    	@{JSDict:Of(ddict).FromiOS(ObjC.Object):Call(obj)};
			    }
			    else {
			    	NSLog(@"Unhandled class JSList.FromiOS: %@", NSStringFromClass([obj class]));
			    }
			}
		@}

		[Foreign(Language.Java)]
		extern(Android) public void FromJava (Java.Object ary)
		@{
			java.util.List l = (java.util.List)ary;
			for (Object obj : l) {
				if (obj instanceof java.util.HashMap) {
					UnoObject ddict = @{JSList:Of(_this).NewDictRow():Call()};
					@{JSDict:Of(ddict).FromJava(Java.Object):Call(obj)};
				}
				else {
					debug_log("Unhandled class JSList.FromJava: " + obj);
				}
			}
		@}

	}

	[ForeignInclude(Language.Java,
					"java.lang.Object",
    	            "java.util.List",
	                "java.util.ArrayList",
	                "java.util.Map",
	                "java.util.HashMap",
	                "android.util.Log")]
	public class JSDict : ForeignDict {
		Context ctx;
		Fuse.Scripting.Object obj;
		public JSDict (Context c) {
			ctx = c;
			obj = ctx.NewObject();
		}

		public Fuse.Scripting.Object GetScriptingObject () {
			return obj;
		}

		[Foreign(Language.ObjC)]
		extern(iOS) public void FromiOS (ObjC.Object dict)
		@{
			for(id key in dict) {
				
				::id value = [dict objectForKey:key];
			    
			    if ([value isKindOfClass:[NSString class]]) {
			        @{JSDict:Of(_this).SetKeyVal(string, string):Call(key, value)};
			    }
			    else if ([value isKindOfClass:[NSDictionary class]]) {
			    	id<UnoObject> ddict = @{JSDict:Of(_this).AddDictForKey(string):Call(key)};
			    	@{JSDict:Of(ddict).FromiOS(ObjC.Object):Call(value)};
			    }
			    else if ([value isKindOfClass:[NSNumber class]]) {

					@{JSDict:Of(_this).SetKeyVal(string, string):Call(key, [value stringValue])};
			    }
			    else if ([value isKindOfClass:[NSArray class]]) {

			    	id<UnoObject> array = @{JSDict:Of(_this).AddListForKey(string):Call(key)};
			    	@{JSList:Of(array).FromiOS(ObjC.Object):Call(value)};
			    }
			    else {
			    	NSLog(@"Unhandled class JSDict.FromiOS: %@", NSStringFromClass([value class]));
			    }
			}
		@}

		[Foreign(Language.Java)]
		extern(Android) public void FromJava (Java.Object dict)
		@{
			java.util.HashMap map = (java.util.HashMap)dict;

			for (Object key : map.keySet()) {

				String key_s = key.toString();
				Object value = map.get(key_s);

				if (value instanceof String) {

					@{JSDict:Of(_this).SetKeyVal(string, string):Call(key_s, value.toString())};
				}
				else if (value instanceof Map) {
				
					UnoObject ddict = @{JSDict:Of(_this).AddDictForKey(string):Call(key)};
			    	@{JSDict:Of(ddict).FromJava(Java.Object):Call(value)};
				}
				else if( value instanceof List) {

		    		UnoObject array = @{JSDict:Of(_this).AddListForKey(string):Call(key)};
			    	@{JSList:Of(array).FromJava(Java.Object):Call(value)};
				}			
			    else {

			    	debug_log("Unhandled class JSDict.FromJava: " + value);
			    }
			}
		@}


		public override void SetKeyVal (string key, string val) {
			obj[key] = val;
		}

		public override ForeignList AddListForKey (string key) {
			var list = new JSList(ctx);
			obj[key] = list.GetScriptingArray();
			return list;
		}

		public override ForeignDict AddDictForKey (string key) {
			var dict = new JSDict(ctx);
			obj[key] = dict.GetScriptingObject();
			return dict;
		}

	}

	public abstract class ListDict {
		public abstract void NewRowSetActive();
		public abstract void SetRow_Column(string key, string val);
	}

	public abstract class ForeignList {
		public abstract ForeignDict NewDictRow();
	}

	public abstract class ForeignDict {
		public abstract ForeignList AddListForKey(string key);
		public abstract ForeignDict AddDictForKey (string key);
		public abstract void SetKeyVal(string key, string val);
	}


}
