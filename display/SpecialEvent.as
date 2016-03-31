/**
 * VERSION: 1.0
 * DATE: 10/09/2010
 * ActionScript 3
 * AUTHOR: J. De Smedt
 **/
package display 
{
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageQuality;
	import flash.display.StageScaleMode;
	import flash.events.Event;

	public class SpecialEvent extends Sprite 
	{
		private const SNOW_PARTICLE_NUMBER:uint = 200;
		private var _stageWidht:Number , _stageHeight:Number;
		private var shape:Shape;
		
		public function SpecialEvent() 
		{
			if ( stage ) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			stage.addEventListener(Event.RESIZE, ResizeHandler);
			
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			stage.quality = StageQuality.BEST;
			_stageWidht = 250;
			_stageHeight = stage.stageHeight;
			this.alpha=0.2;
			
			addBackground();
			addSnow();
			changeDepth()
		}
		
		private function addBackground():void
		{
			var g:Graphics;
			addChild( shape = new Shape() );
			g = shape.graphics;
			g.beginFill( 0x211E21 );
			g.drawRect( 0 , 0 , _stageWidht , _stageHeight );
			g.endFill();
			this.mask=shape;
		}
		
		private function addSnow():void
		{
			var i:uint , snowParticle:SnowParticle;
			
			for ( i = 1; i <= SNOW_PARTICLE_NUMBER; i++ )
			{
				addChild( snowParticle = new SnowParticle( _stageWidht , _stageHeight ) );
				snowParticle.name = i.toString();
			}
		}
		
		private function changeDepth():void
		{
			var i:uint , snowParticle:SnowParticle;
			
			for ( i = 1; i <= SNOW_PARTICLE_NUMBER; i++ )
			{
				snowParticle = getChildByName( i.toString() ) as SnowParticle;
				if ( snowParticle.isBig )
					swapChildrenAt( getChildIndex(snowParticle ) , numChildren - 1 );
			}
		}
		
		private function ResizeHandler(event:Event):void
		{
			//SnowParticle._stageWidth = stage.stageWidth;
			SnowParticle._stageHeight = stage.stageHeight;
			//shape.width = stage.stageWidth;
			shape.height = stage.stageHeight;
		}
	}
}

import flash.display.Graphics;
import flash.display.Shape;
import flash.display.Sprite;
import flash.events.Event;
import flash.filters.BlurFilter;

class SnowParticle extends Sprite
{
	private const PARTICLE_MAX_SIZE:uint = 40;
	private const MAX_SPPED:uint = 5;
	
	public static var _stageWidth		:uint;
	public static var _stageHeight		:uint;
	private var _particle			:Shape;
	private var _size			:Number;
	private var _sx				:Number;
	private var _sy				:Number;
	private var _isBig			:Boolean 		= false;
	private var _basePosition		:Number;
	
	public function SnowParticle( stageWidth:uint , stageHeight:uint ):void
	{
		_stageWidth = stageWidth;
		_stageHeight = stageHeight;
		init();
	}
	
	private function init():void
	{
		checkBig();
		addSnow();
		setPosition();
		setSpeed();
		setFilter();
		moveSnow();
	}
	
	private function checkBig():void
	{
		if ( Math.round( Math.random() * 10 ) == 10 )
			_isBig = true;
	}
	
	private function addSnow():void
	{
		var g:Graphics , i:uint , pi:Number , angle:Number;
		
		addChild( _particle = new Shape() );
		
		if ( !_isBig )
		{
			_size = Math.random() * PARTICLE_MAX_SIZE / 10;
			_particle.alpha = _size / ( PARTICLE_MAX_SIZE / 10 ) * Math.random() + 0.3;
		}
		else
		{
			_size = Math.random() * PARTICLE_MAX_SIZE + PARTICLE_MAX_SIZE / 4;
			_particle.alpha = Math.random() * 0.7 + 0.2;
		}
		
		g = _particle.graphics;
		g.beginFill( 0xffffff );
		g.moveTo( _size , 0 );
		
		pi = Math.PI / 180;
		for( i = 0; i < 6;i++)
		{
			angle = 60 * i;
			g.lineTo( _size * Math.cos( pi * angle ) , _size * Math.sin( pi * angle ) );
		}
		g.lineTo( _size , 0);
	}
	
	private function setPosition():void
	{
		_particle.x = Math.random() * _stageWidth;
		_particle.y = Math.random() * _stageHeight * -1;
		
		_basePosition = _size >> 1;
	}
	
	private function setSpeed():void
	{
		var speedY:Number;
		
		if( !_isBig )
			speedY = Math.random() * MAX_SPPED +  + ( MAX_SPPED >> 1 );
		else
			speedY = Math.random() * MAX_SPPED * 6 + ( MAX_SPPED >> 1 );
		_sy = speedY;
		_sx = ( Math.random() * 1 < 0.6 ) ? Math.random() * ( MAX_SPPED >> 1 ) : Math.random() * ( MAX_SPPED >> 1 ) * -1;
	}
	
	private function setFilter():void
	{
		if( !_isBig )
			_particle.filters = [ new BlurFilter( _size << 1 , _size << 1 ) ];
		else
			_particle.filters = [ new BlurFilter( 32 , 32 ) ];
	}
	
	private function moveSnow():void
	{
		_particle.addEventListener( Event.ENTER_FRAME , enterFrameHandler );
	}
	
	private function enterFrameHandler( $evt:Event ):void
	{
		_particle.scaleX = _particle.scaleY = Math.random() * 1 + 0.8;
		if ( _particle.scaleX > 1 ) _particle.scaleX = _particle.scaleY = 1;
		
		_particle.x += _sx;
		_particle.y += _sy;
		
		if ( _particle.y - _basePosition > _stageHeight || _particle.x + _basePosition < 0 || _particle.x - _basePosition > _stageWidth )
		{
			setPosition();
			setSpeed();
			setFilter();
		}
	}
	
	public function get isBig():Boolean { return _isBig; }
}
