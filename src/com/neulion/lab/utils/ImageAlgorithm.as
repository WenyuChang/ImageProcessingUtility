package com.neulion.lab.utils
{
	import flash.display.BitmapData;
	
	import mx.collections.ArrayCollection;
	
	public class ImageAlgorithm
	{
		public static var a : uint = 0;
		public static var b : uint = 256;
		public static var c : uint = 30;
		public static var d : uint = 100;
		
		
		public static var k : uint = 90;
		
		private static var flag : Boolean = false;
		
		private static var count:Array, count2:Array, acum:Array, operator:Array, new_color:Array;
		
		
		public function ImageAlgorithm()
		{
			
		}
		
		public static function grayscale(source : BitmapData) : BitmapData
		{
			
			var count = new Array(256);
			var acum = new Array(256);
			var new_color = new Array(256);
		
			for (var m : uint = 0; m < count.length; m++)
			{
				count[m] = 0;
				acum[m] = 0;
				new_color[m] = 0;
			}
		
		
			var data : BitmapData = new BitmapData(source.width, source.height);
		
	    	for (var i : uint = 1; i < source.width; i++)
	     	{
	    		for(var j : uint = 1; j < source.height; j++)
	         	{
	      			var gray : uint = source.getPixel(i,j) >> 16;
	      			trace(gray);
	         		for(var k : uint = 0; k < 256;k++)
	         		{
		         		if(gray == k)
		         		{
		                	count[k]++;
		                	acum[k]++;
		           		}
		          	}
	         	}
	     	}
     	
		 	for (i = 1; i < 256; i++)
		 	{
		    	acum[i] += acum[i-1];
			}
		
		 	for (i = 0; i < 256; i++) 
			{        	 
		    	j = acum[i] * 256 / (source.width*source.height);
				if (j >= 0 && j < a)
				{
					j = c;
				}
				if (j >= a && j < b)
				{
					j = (d-c) * (j-a) / (b-a) + c;
				}
				if (j >= b && j < 256)
				{
					j = d;
				}
		    	new_color[i] = Math.round(j);
			}
		
	     
		    for (var i : uint = 1; i < source.width; i++)
	     	{
	    		for(var j : uint = 1;j < source.height; j++)
	         	{
	         		gray = source.getPixel(i,j) >> 16;
		    		data.setPixel(i,j,(new_color[gray] << 16)|(new_color[gray] << 8) | new_color[gray]);
	         	}
		    }
		    
			return data;
		}
		
		public static function binarization(source : BitmapData) : BitmapData
	   	{
	   		var data:BitmapData = new BitmapData(source.width, source.height);
			
			for(var i:int=1;i<source.width;i++)
			{
				for(var j:int=1;j<source.height;j++)
				{
					var gray:uint = (source.getPixel(i,j))>>16;
					trace(gray);
					
					gray = gray > k ? 255 : 0;
					data.setPixel(i,j,(gray<<16)|(gray<<8)|gray);
				}
			}
			return data;
	   	}
	   	
	   	public static function histogram(source : BitmapData) : BitmapData
		{
			var count = new Array(256);
			var acum = new Array(256);
			var new_color = new Array(256);
		
			for (var m : uint = 0; m < count.length; m++)
			{
				count[m] = 0;
				acum[m] = 0;
				new_color[m] = 0;
			}
		
			var data:BitmapData = new BitmapData(source.width,source.height);
		
    		for(var i:Number=1;i<source.width;i++)
     		{
	    		for(var j:Number=1;j<source.height;j++)
	         	{
	         		var gray:uint = source.getPixel(i,j) >> 16;
      			
         			for(var k:uint = 0;k<256;k++)
         			{
	         			if(gray == k)
	         			{
		                	count[k]++;
		                	acum[k]++;
	           			}
	          		}
	         	}
	     	}
    		for(i=1;i<256;i++)
	    	{
	        	acum[i] += acum[i-1];
	     	}
     	
	    	for(i=0;i<256;i++)
		 	{
	       		j = acum[i] * 256 / (source.width*source.height);
	        	if(j>255)
				{
					j=255;
				}
	            new_color[i] = Math.round(j);
			}
		
	     	for(i=1;i<source.width;i++)
	     	{
	    		for(j=1;j<source.height;j++)
	         	{
	         		gray = source.getPixel(i,j) >> 16;
		    		data.setPixel(i,j,(new_color[gray]<<16)|(new_color[gray]<<8)|new_color[gray]);
	         	}
		    }
			return data;
		}
		
		public static function median(source:BitmapData):BitmapData
		{
			var operator = new Array(9);
			
			for (var m:int=0;m<operator.length;m++)
			{
				operator[m] = 0;
			}
			var data:BitmapData = new BitmapData(source.width,source.height);
			
			for(var i:int=1;i<source.width;i++)
			{
				for(var j:int=1;j<source.height;j++)
				{
					if(i==1	|| j==1 || j==source.width || i==source.height)
				    {
				   		data.setPixel(i,j,source.getPixel(i,j));
					}
					else
					{
						// 1 2 3
						// 4 i 6
						// 7 8 9
						operator[0]=source.getPixel(i-1,j-1);
					  	operator[1]=source.getPixel(i,j-1)
					  	operator[2]=source.getPixel(i+1,j-1);
					  	operator[3]=source.getPixel(i-1,j);
					  	operator[4]=source.getPixel(i,j);
					  	operator[5]=source.getPixel(i+1,j);
					 	operator[6]=source.getPixel(i-1,j+1);
					 	operator[7]=source.getPixel(i,j+1);
					  	operator[8]=source.getPixel(i+1,j+1);

						for(m=0;m<9;m++)
						{
					    	for(var n:int=0;n<9;n++)
						 	{
							 	if(operator[n]>operator[n+1])
							 	{
									var t:int = operator[n];
									operator[n] = operator[n+1];
									operator[n+1] = t;
							 	}
						 	}
						 	data.setPixel(i,j,operator[4]);
						}
				 	}
				}
			}
			return data;
		}
		
		public static function box3(source:BitmapData):BitmapData
		{
			var data:BitmapData = new BitmapData(source.width,source.height);
			
			for(var i:int=1;i<source.width;i++)
			{
				for(var j:int=1;j<source.height;j++)
				{
					// 1st column || 1st row || last column || last row
					if(i==1	|| j==1 || j==source.width || i==source.height)
					{
				   		data.setPixel(i,j,source.getPixel(i,j));
					}
					else
					{
						var gray:Number = (
									(source.getPixel(i-1,j-1)>>16)
									+(source.getPixel(i,j-1)>>16)
									+(source.getPixel(i+1,j-1)>>16)
									+(source.getPixel(i-1,j)>>16)
									+(source.getPixel(i,j)>>16)
									+(source.getPixel(i+1,j)>>16)
									+(source.getPixel(i-1,j+1)>>16)
									+(source.getPixel(i,j+1)>>16)
									+(source.getPixel(i+1,j+1)>>16)
									)/9;
						gray = Math.round(gray);
						data.setPixel(i,j,gray<<16|gray<<8|gray);
					}
				}
			}
			return data;
		}
		
		public static function box5(source:BitmapData):BitmapData
		{
			var data:BitmapData = new BitmapData(source.width,source.height);
			
			for(var i:int=1;i<source.width;i++)
			{
				for(var j:int=1;j<source.height;j++)
				{
					// first 2 column || last 2 column || first 2 row || last 2 row
					if(j<=2 || j==source.width || i==source.width-1 || i<=2 || i==source.height || i==source.height-1)
					{
				   		data.setPixel(i,j,source.getPixel(i,j));
					}
					else
					{
						var gray:Number = (
									(source.getPixel(i-2,j-2)>>16)
									+(source.getPixel(i-1,j-2)>>16)
									+(source.getPixel(i,j-2)>>16)
									+(source.getPixel(i+1,j-2)>>16)
									+(source.getPixel(i+2,j-2)>>16)
									
									+(source.getPixel(i-2,j-1)>>16)
									+(source.getPixel(i-1,j-1)>>16)
									+(source.getPixel(i,j-1)>>16)
									+(source.getPixel(i+1,j-1)>>16)
									+(source.getPixel(i+2,j-1)>>16)
									
									+(source.getPixel(i-2,j)>>16)
									+(source.getPixel(i-1,j)>>16)
									+(source.getPixel(i,j)>>16)
									+(source.getPixel(i+1,j)>>16)
									+(source.getPixel(i+2,j)>>16)
									
									+(source.getPixel(i-2,j+1)>>16)
									+(source.getPixel(i-1,j+1)>>16)
									+(source.getPixel(i,j+1)>>16)
									+(source.getPixel(i+1,j+1)>>16)
									+(source.getPixel(i+2,j+1)>>16)
									
									+(source.getPixel(i-2,j+2)>>16)
									+(source.getPixel(i-1,j+2)>>16)
									+(source.getPixel(i,j+2)>>16)
									+(source.getPixel(i+1,j+2)>>16)
									+(source.getPixel(i+2,j+2)>>16)
									)/25;
						   
						gray = Math.round(gray);
						data.setPixel(i,j,gray<<16|gray<<8|gray);
					}
				}
			}
			return data;
		}
		
		public static function pseudoColor(source:BitmapData):BitmapData
		{
			var r:uint = 0,g:uint = 0,b:uint = 0;
		    var m:uint = 0,n:uint = 0;
		    var gray:uint = 0;
		    var data:BitmapData = new BitmapData(source.width,source.height);
		    
		    m = 4;
		    n = 255;
		    
		    for(var i:int=0;i<source.width;i++)
			{
				for(var j:int=0;j<source.height;j++)
				{
					gray = (source.getPixel(i,j)>>16);
		                
		            if(gray<64)
					{
						r=0; g=m*gray; b=n;
						
						if(g>n)
						{
							g=n;
						}
					}
		            else if(gray<128)
					{
						r=0; g=n; b=m*(128-gray);
		                    
		                if(b>n)
		                {
		                	b=n;
		                }
		            }
		            else if(gray<192)
		            {
		            	r=m*(gray-128); g=n; b=0;
		            	
		            	if(r>n)
		            	{
		            		r=n;
		            	}
		            }
		            else
		            {
		            	r=n; g=m*(256-gray); b=0;
		                
		                if(g>n)
		                {
		                	g=n;
		                }
					}
					data.setPixel(i,j,r<<16|g<<8|b);
				}
			}
			if(flag)
			{
				countImageInfo(source);
			}
			
			return data;
		}
		
		//Roberts算子
		public static function roberts(source:BitmapData):BitmapData
		{
			var data:BitmapData = new BitmapData(source.width,source.height);
			var gray:uint = 0;
				
			for(var i:int=0;i<source.width;i++)
			{
				for(var j:int=0;j<source.height;j++)
				{
					if((j<1 || j==source.width-1) && (i<1 || i==source.height-1))
					{
				   		data.setPixel(i,j,source.getPixel(i,j));
					}
					else
					{
						gray = Math.abs((source.getPixel(i,j)>>16)-(source.getPixel(i+1,j+1)>>16)) + Math.abs((source.getPixel(i+1,j)>>16)-(source.getPixel(i,j+1)>>16));
					
						if(gray>255)
						{
							gray=255;
						}
						if(gray<0)
						{
							gray=0;
						}
						data.setPixel(i,j,gray<<16|gray<<8|gray);
					}
				}
			}
			if(flag)
			{
				countImageInfo(source);
				countImageInfo2(data);
			}
			
			return data;
		}
		
		//Prewitt算子
		public static function prewitt(source:BitmapData):BitmapData
		{
			var data:BitmapData = new BitmapData(source.width,source.height);
			var gray:uint = 0;
			
			for(var i:int=0;i<source.width;i++)
			{
				for(var j:int=0;j<source.height;j++)
				{
					if((j<1 || j==source.width-1) && (i<1 || i==source.height-1))
					{
				   		data.setPixel(i,j,source.getPixel(i,j));
					}
					else
					{
						gray = Math.abs( ((source.getPixel(i-1,j+1)>>16)+(source.getPixel(i,j+1)>>16)+(source.getPixel(i+1,j+1)>>16)) - ((source.getPixel(i-1,j-1)>>16)+(source.getPixel(i,j-1)>>16)+(source.getPixel(i+1,j-1)>>16)) )
						     + Math.abs( ((source.getPixel(i+1,j-1)>>16)+(source.getPixel(i+1,j)>>16)+(source.getPixel(i+1,j+1)>>16)) - ((source.getPixel(i-1,j-1)>>16)+(source.getPixel(i-1,j)>>16)+(source.getPixel(i-1,j+1)>>16)) );
						if(gray>255)
						{
							gray=255;
						}
						if(gray<0)
						{
							gray=0;
						}
						data.setPixel(i,j,gray<<16|gray<<8|gray);
					}
				}
			}
			if(flag)
			{
				countImageInfo(source);
				countImageInfo2(data);
			}
			
			return data;
		}
		
		//Sobel算子
		public static function sobel(source:BitmapData):BitmapData
		{
			var data:BitmapData = new BitmapData(source.width,source.height);
			var gray:uint = 0;
			
			for(var i:int=0;i<source.width;i++)
			{
				for(var j:int=0;j<source.height;j++)
				{
					if((j<2 || j==source.width-1 || j==source.width-2) && (i<2 || i==source.height-1 || i==source.height-2))
					{
				   		data.setPixel(i,j,source.getPixel(i,j));
					}
					else
					{
						gray = Math.abs( ((source.getPixel(i+1,j-1)>>16)+2*(source.getPixel(i+1,j)>>16)+(source.getPixel(i+1,j+1)>>16)) - ((source.getPixel(i-1,j-1)>>16)+2*(source.getPixel(i-1,j)>>16)+(source.getPixel(i-1,j+1)>>16)) )
						     + Math.abs( ((source.getPixel(i-1,j+1)>>16)+2*(source.getPixel(i,j+1)>>16)+(source.getPixel(i+1,j+1)>>16)) - ((source.getPixel(i-1,j-1)>>16)+2*(source.getPixel(i,j-1)>>16)+(source.getPixel(i+1,j-1)>>16)) );
						if(gray>255)
						{
							gray=255;
						}
						if(gray<0)
						{
							gray=0;
						}
						data.setPixel(i,j,gray<<16|gray<<8|gray);
					}
				}
			}
			if(flag)
			{
				countImageInfo(source);
				countImageInfo2(data);
			}
			
			return data;
		}
		
		//Log算子
		public static function laplace(source:BitmapData):BitmapData
		{
			var data:BitmapData = new BitmapData(source.width,source.height);
			var gray:uint = 0;
			
			for(var i:int=0;i<source.width;i++)
			{
				for(var j:int=0;j<source.height;j++)
				{
					if((j<2 || j>source.width-3) && (i<2 || i>source.height-3))
					{
				   		data.setPixel(i,j,source.getPixel(i,j));
					}
					else
					{
						gray = Math.abs( 24*(source.getPixel(i,j)>>16)+8*( (source.getPixel(i,j-1)>>16)+(source.getPixel(i,j+1)>>16)+(source.getPixel(i-1,j)>>16)+(source.getPixel(i+1,j)>>16) )
							 		  -4*( (source.getPixel(i-2,j-1)>>16)+(source.getPixel(i-2,j)>>16)+(source.getPixel(i-2,j+1)>>16)+(source.getPixel(i-1,j-2)>>16)+(source.getPixel(i-1,j+2)>>16)+(source.getPixel(i,j-2)>>16)
							 		  	  +(source.getPixel(i,j+2)>>16)+(source.getPixel(i+1,j-2)>>16)+(source.getPixel(i+1,j+2)>>16)+(source.getPixel(i+2,j-1)>>16)+(source.getPixel(i+2,j)>>16)+(source.getPixel(i+2,j+1)>>16) )
							 		  -2*( (source.getPixel(i-2,j-2)>>16)+(source.getPixel(i-2,j+2)>>16)+(source.getPixel(i+2,j-2)>>16)+(source.getPixel(i+2,j+2)>>16) )
							 		  	); 
						if(gray>255)
						{
							gray=255;
						}
						if(gray<0)
						{
							gray=0;
						}
						data.setPixel(i,j,gray<<16|gray<<8|gray);
					}
				}
			}
			if(flag)
			{
				countImageInfo(source);
				countImageInfo2(data);
			}
			
			return data;
		}
		
		private static function countImageInfo(source:BitmapData):void
		{
			var count = new Array(256);
			var acum = new Array(256);
			var new_color = new Array(256);
			
			for (var m:int = 0;m<count.length;m++)
			{
				count[m] = 0;
				acum[m] = 0;
				new_color[m] = 0;
			}
				
			var data:BitmapData = new BitmapData(source.width,source.height);
				
		    for(var i:Number=0;i<source.width;i++)
		    {
		    	for(var j:Number=0;j<source.height;j++)
		       	{
		    		var gray:uint = (source.getPixel(i,j)>>16);
		      			
		       		for(var k:uint = 0;k<256;k++)
		       		{
			       		if(gray == k)
			       		{
			               	count[k]++;
			               	acum[k]++;
			       		}
			       	}
		       	}
		    }
		    
			for(i=1;i<256;i++)
			{
			   	acum[i] += acum[i-1];
			}
			if(flag)
			{
				CreateLineChart();
			}
		}
		
		private static function countImageInfo2(source:BitmapData):void
		{
			var count2 = new Array(256);
			
			for (var m:int = 0;m<count2.length;m++)
			{
				count2[m] = 0;
			}
				
			var data:BitmapData = new BitmapData(source.width,source.height);
				
		    for(var i:Number=0;i<source.width;i++)
		    {
		    	for(var j:Number=0;j<source.height;j++)
		       	{
		    		var gray:uint = (source.getPixel(i,j)>>16);
		      			
		       		for(var k:uint = 0;k<256;k++)
		       		{
			       		if(gray == k)
			       		{
			               	count2[k]++;
			       		}
			       	}
		       	}
		    }
		    
			if(flag)
			{
				CreateLineChart2();
			}
		}
		
		private static function CreateLineChart():void
		{
			var oArr = new ArrayCollection();
			for(var i:int=0;i<count.length;i++)
			{
				oArr.addItem({x:i, y:count[i]});
			}
		}
		
		private static function CreateLineChart2():void
		{
			var nArr = new ArrayCollection();
			for(var i:int=0;i<count2.length;i++)
			{
				nArr.addItem({x:i, y:count2[i]});
			}
		}

	}

}