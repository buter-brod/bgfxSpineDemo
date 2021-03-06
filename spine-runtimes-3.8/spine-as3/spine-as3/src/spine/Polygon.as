/******************************************************************************
 * Spine Runtimes License Agreement
 * Last updated January 1, 2020. Replaces all prior versions.
 *
 * Copyright (c) 2013-2020, Esoteric Software LLC
 *
 * Integration of the Spine Runtimes into software or otherwise creating
 * derivative works of the Spine Runtimes is permitted under the terms and
 * conditions of Section 2 of the Spine Editor License Agreement:
 * http://esotericsoftware.com/spine-editor-license
 *
 * Otherwise, it is permitted to integrate the Spine Runtimes into software
 * or otherwise create derivative works of the Spine Runtimes (collectively,
 * "Products"), provided that each user of the Products must obtain their own
 * Spine Editor license and redistribution of the Products in any form must
 * include this license and copyright notice.
 *
 * THE SPINE RUNTIMES ARE PROVIDED BY ESOTERIC SOFTWARE LLC "AS IS" AND ANY
 * EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED. IN NO EVENT SHALL ESOTERIC SOFTWARE LLC BE LIABLE FOR ANY
 * DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES,
 * BUSINESS INTERRUPTION, OR LOSS OF USE, DATA, OR PROFITS) HOWEVER CAUSED AND
 * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
 * THE SPINE RUNTIMES, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *****************************************************************************/

package spine {
	public class Polygon {
		public var vertices : Vector.<Number> = new Vector.<Number>();

		public function Polygon() {
		}

		/** Returns true if the polygon contains the point. */
		public function containsPoint(x : Number, y : Number) : Boolean {
			var nn : int = vertices.length;

			var prevIndex : int = nn - 2;
			var inside : Boolean = false;
			for (var ii : int = 0; ii < nn; ii += 2) {
				var vertexY : Number = vertices[ii + 1];
				var prevY : Number = vertices[prevIndex + 1];
				if ((vertexY < y && prevY >= y) || (prevY < y && vertexY >= y)) {
					var vertexX : Number = vertices[ii];
					if (vertexX + (y - vertexY) / (prevY - vertexY) * (vertices[prevIndex] - vertexX) < x) inside = !inside;
				}
				prevIndex = ii;
			}

			return inside;
		}

		/** Returns true if the polygon contains the line segment. */
		public function intersectsSegment(x1 : Number, y1 : Number, x2 : Number, y2 : Number) : Boolean {
			var nn : int = vertices.length;

			var width12 : Number = x1 - x2, height12 : Number = y1 - y2;
			var det1 : Number = x1 * y2 - y1 * x2;
			var x3 : Number = vertices[nn - 2], y3 : Number = vertices[nn - 1];
			for (var ii : int = 0; ii < nn; ii += 2) {
				var x4 : Number = vertices[ii], y4 : Number = vertices[ii + 1];
				var det2 : Number = x3 * y4 - y3 * x4;
				var width34 : Number = x3 - x4, height34 : Number = y3 - y4;
				var det3 : Number = width12 * height34 - height12 * width34;
				var x : Number = (det1 * width34 - width12 * det2) / det3;
				if (((x >= x3 && x <= x4) || (x >= x4 && x <= x3)) && ((x >= x1 && x <= x2) || (x >= x2 && x <= x1))) {
					var y : Number = (det1 * height34 - height12 * det2) / det3;
					if (((y >= y3 && y <= y4) || (y >= y4 && y <= y3)) && ((y >= y1 && y <= y2) || (y >= y2 && y <= y1))) return true;
				}
				x3 = x4;
				y3 = y4;
			}
			return false;
		}
	}
}
