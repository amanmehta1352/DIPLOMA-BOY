function _dl(x){ return Array.isArray(x) ? '<span class="hi">' + x[0] + '</span><span class="en">' + x[1] + '</span>' : x; }
function makeDemoDoc(title, hint, sliderLabel, min, max, step, val, scriptBody) {
  title = _dl(title); hint = _dl(hint); sliderLabel = _dl(sliderLabel);
  return '<!DOCTYPE html><html lang="hi"><head><meta charset="UTF-8">' +
  '<meta name="viewport" content="width=device-width, initial-scale=1.0">' +
  '<style>*{box-sizing:border-box;margin:0;padding:0}html,body{height:100%;background:#0f172a;color:#e2e8f0;font-family:Inter,"Noto Sans Devanagari",sans-serif;overflow:hidden}' +
  '#app{height:100%;display:flex;flex-direction:column}#title{padding:8px 12px;font-size:14px;font-weight:700;color:#5eead4}' +
  '#stage{flex:1;position:relative;min-height:0}#stage canvas{position:absolute;inset:0;width:100%;height:100%;display:block}' +
  '#info{padding:6px 12px;font-size:13px;color:#fde68a;min-height:36px}.ctrl{padding:6px 12px 12px;display:flex;align-items:center;gap:10px}' +
  '.ctrl label{font-size:13px;min-width:90px}input[type=range]{flex:1;height:40px;accent-color:#5eead4}#val{min-width:64px;text-align:right;color:#5eead4;font-weight:700}body[data-lang=hi] .en,body[data-lang=en] .hi{display:none}body[data-lang=both] .en::before{content:" / "}</style></head><body data-lang="__LANG__">' +
  '<div id="app"><div id="title">' + title + '</div><div id="stage"></div><div id="info">' + hint + '</div>' +
  '<div class="ctrl"><label>' + sliderLabel + '</label><input id="s" type="range" min="' + min + '" max="' + max + '" step="' + step + '" value="' + val + '"><div id="val"></div></div></div>' +
  '<script src="https://cdnjs.cloudflare.com/ajax/libs/three.js/r128/three.min.js"><\/script>' +
  '<script>' +
  'const stage=document.getElementById("stage");const renderer=new THREE.WebGLRenderer({antialias:true});' +
  'renderer.setPixelRatio(Math.min(devicePixelRatio,2));stage.appendChild(renderer.domElement);' +
  'const scene=new THREE.Scene();scene.background=new THREE.Color(0x0f172a);' +
  'const camera=new THREE.PerspectiveCamera(50,1,0.1,200);camera.position.set(0,6,12);camera.lookAt(0,1,0);' +
  'scene.add(new THREE.AmbientLight(0xffffff,0.8));const sun=new THREE.DirectionalLight(0xffffff,0.6);sun.position.set(4,8,6);scene.add(sun);' +
  'function mat(c){return new THREE.MeshStandardMaterial({color:c,roughness:0.5});}' +
  'function line(a,b,c){const g=new THREE.BufferGeometry().setFromPoints([a,b]);return new THREE.Line(g,new THREE.LineBasicMaterial({color:c}));}' +
  'function arrow(from,to,c){const d=new THREE.Vector3().subVectors(to,from);const len=d.length();const g=new THREE.Group();' +
  'const shaft=new THREE.Mesh(new THREE.CylinderGeometry(0.05,0.05,Math.max(len-0.3,0.01),12),mat(c));' +
  'const head=new THREE.Mesh(new THREE.ConeGeometry(0.14,0.3,12),mat(c));shaft.position.y=(len-0.3)/2;head.position.y=len-0.15;g.add(shaft,head);' +
  'g.position.copy(from);g.quaternion.setFromUnitVectors(new THREE.Vector3(0,1,0),d.normalize());scene.add(g);objs.push(g);return g;}' +
  'function resize(){const w=stage.clientWidth,h=stage.clientHeight;renderer.setSize(w,h,false);camera.aspect=w/h;const k=Math.max(1,1.25/camera.aspect);camera.position.set(0,6*k,12*k);camera.lookAt(0,1,0);camera.updateProjectionMatrix();}' +
  'window.addEventListener("resize",resize);resize();' +
  'const objs=[];function clear(){while(objs.length){const o=objs.pop();scene.remove(o);}}' +
  'function add(o){scene.add(o);objs.push(o);return o;}' +
  'const LANG=document.body.dataset.lang||"hi";function T(h,e){return LANG==="en"?e:h;}const info=document.getElementById("info");const s=document.getElementById("s");const valEl=document.getElementById("val");' +
  'function update(v){clear();' + scriptBody + '}' +
  's.addEventListener("input",()=>{valEl.textContent=s.value;update(parseFloat(s.value));});' +
  'valEl.textContent=s.value;update(parseFloat(s.value));' +
  '(function loop(){requestAnimationFrame(loop);renderer.render(scene,camera);})();' +
  '<\/script></body></html>';
}

