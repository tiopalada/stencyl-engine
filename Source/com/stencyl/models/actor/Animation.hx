package com.stencyl.models.actor;

import nme.display.BitmapData;
import box2D.dynamics.B2FixtureDef;

class Animation
{
	public var animID:Int;
	public var animName:String;
	
	public var parentID:Int;
	public var simpleShapes:IntHash<Dynamic>;
	public var physicsShapes:IntHash<Dynamic>;
	public var looping:Bool;
	public var sync:Bool;
	public var durations:Array<Int>;
	
	public var imgData:Dynamic;
	public var imgWidth:Int;
	public var imgHeight:Int;
	
	public var framesAcross:Int;
	public var framesDown:Int;
	
	public var originX:Float;
	public var originY:Float;
	
	public var sharedTimer:Float = 0;
	public var sharedFrameIndex:Int = 0;
	
	public static var allAnimations:Array<Animation> = new Array<Animation>();
	
	public function new
	(
		animID:Int,
		animName:String,
		parentID:Int, 
		simpleShapes:IntHash<Dynamic>, 
		physicsShapes:IntHash<Dynamic>, 
		looping:Bool, 
		sync:Bool,
		imgWidth:Int,
		imgHeight:Int,
		originX:Float,
		originY:Float,
		durations:Array<Int>, 
		framesAcross:Int, 
		framesDown:Int,
		atlasID:Int
	)
	{
		this.animID = animID;
		this.animName = animName;
		
		this.parentID = parentID;
		this.simpleShapes = simpleShapes;
		this.physicsShapes = physicsShapes;
		this.looping = looping;
		this.sync = sync;
		this.durations = durations;

		this.imgWidth = imgWidth;
		this.imgHeight = imgHeight;
		
		this.framesAcross = framesAcross;
		this.framesDown = framesDown;
		
		this.originX = originX;
		this.originY = originY;
		
		var atlas = GameModel.get().atlases.get(atlasID);
			
		if(atlas != null && atlas.active)
		{
			loadGraphics();
		}
		
		if(framesAcross > 1 && looping)
		{
			allAnimations.push(this);
		}
	}
	
	//For Atlases
	
	public function loadGraphics()
	{
		imgData = Data.get().getGraphicAsset
		(
			parentID + "-" + animID + ".png",
			"assets/graphics/" + Engine.IMG_BASE + "/sprite-" + parentID + "-" + animID + ".png"
		);
	}
	
	public function unloadGraphics()
	{
		//Graceful fallback - just a blank image that is numFrames across in px
		imgData = new BitmapData(framesAcross, 1);
		Data.get().resourceAssets.remove(parentID + "-" + animID + ".png");
	}
	
	public static function updateAll(elapsedTime:Float)
	{
		for(a in allAnimations)
		{
			a.update(elapsedTime);
		}
	}
	
	public inline function update(elapsedTime:Float)
	{
		sharedTimer += elapsedTime;
		
		if(framesAcross > 1 && sharedTimer > durations[sharedFrameIndex])
		{
			var old = sharedFrameIndex;
		
			sharedTimer -= durations[sharedFrameIndex];
			
			sharedFrameIndex++;
			
			if(sharedFrameIndex >= framesAcross)
			{
				if(looping)
				{
					sharedFrameIndex = 0;
				}
				
				else
				{	
					sharedFrameIndex--;
				}
			}
		}
	}
}