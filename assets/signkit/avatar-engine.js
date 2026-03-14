import * as THREE from './vendor/three.module.js';
import { GLTFLoader } from './vendor/GLTFLoader.js';
import { defaultPose } from './animations/defaultPose.js';
import { LETTER_DICTIONARY, WORD_DICTIONARY } from './dictionary.js';

const container = document.getElementById('avatar-root');

const ref = {
  scene: new THREE.Scene(),
  renderer: null,
  camera: null,
  avatar: null,
  animations: [],
  characters: [],
  pending: false,
  flag: false,
  pause: 180,
  speed: 0.1,
  modelName: 'ybot',
  animate: () => {
    ref.pending = true;
  },
};

const loader = new GLTFLoader();
let pauseTimeout = null;
let statusEl = null;

function setStatus(message) {
  if (!statusEl) {
    statusEl = document.createElement('div');
    statusEl.style.position = 'absolute';
    statusEl.style.left = '8px';
    statusEl.style.right = '8px';
    statusEl.style.bottom = '8px';
    statusEl.style.padding = '6px 8px';
    statusEl.style.borderRadius = '8px';
    statusEl.style.background = 'rgba(0, 0, 0, 0.55)';
    statusEl.style.color = '#e5eefc';
    statusEl.style.font = '12px sans-serif';
    statusEl.style.zIndex = '10';
    statusEl.style.pointerEvents = 'none';
    container.appendChild(statusEl);
  }
  statusEl.textContent = message;
}

function setupScene() {
  ref.renderer = new THREE.WebGLRenderer({ antialias: true, alpha: true, powerPreference: 'low-power' });
  ref.renderer.setPixelRatio(Math.min(window.devicePixelRatio || 1, 1.5));
  ref.renderer.outputEncoding = THREE.sRGBEncoding;
  ref.renderer.setClearColor(0x000000, 0);

  ref.camera = new THREE.PerspectiveCamera(28, 1, 0.1, 1000);
  ref.camera.position.set(0, 1.35, 2.35);
  ref.camera.lookAt(0, 1.05, 0);

  const ambient = new THREE.AmbientLight(0xffffff, 1.6);
  const key = new THREE.DirectionalLight(0xffffff, 1.1);
  key.position.set(0.6, 1.9, 1.5);
  const fill = new THREE.DirectionalLight(0x9ecbff, 0.45);
  fill.position.set(-1.1, 1.2, 1.0);

  ref.scene.add(ambient, key, fill);
  container.innerHTML = '';
  container.appendChild(ref.renderer.domElement);
  setStatus('Loading avatar...');
  resize();
}

function resize() {
  const width = container.clientWidth || 220;
  const height = container.clientHeight || 220;
  ref.camera.aspect = width / height;
  ref.camera.updateProjectionMatrix();
  ref.renderer.setSize(width, height, false);
}

async function loadAvatar(modelName = 'ybot') {
  const path = `./models/${modelName}/${modelName}.glb`;
  ref.modelName = modelName;

  const gltf = await loader.loadAsync(path);
  if (ref.avatar) {
    ref.scene.remove(ref.avatar);
  }

  gltf.scene.traverse((child) => {
    if (child.type === 'SkinnedMesh') {
      child.frustumCulled = false;
    }
  });

  ref.avatar = gltf.scene;
  const box = new THREE.Box3().setFromObject(ref.avatar);
  const size = new THREE.Vector3();
  const center = new THREE.Vector3();
  box.getSize(size);
  box.getCenter(center);

  const targetHeight = 2.0;
  const scale = size.y > 0 ? targetHeight / size.y : 1;
  ref.avatar.scale.setScalar(scale);

  const scaledBox = new THREE.Box3().setFromObject(ref.avatar);
  const scaledCenter = new THREE.Vector3();
  scaledBox.getCenter(scaledCenter);
  ref.avatar.position.x = -scaledCenter.x;
  ref.avatar.position.z = -scaledCenter.z;
  ref.avatar.position.y = -scaledBox.min.y;

  ref.scene.add(ref.avatar);
  ref.camera.lookAt(0, 1.05, 0);

  ref.animations = [];
  ref.characters = [];
  ref.pending = false;
  ref.flag = false;
  if (pauseTimeout) {
    clearTimeout(pauseTimeout);
    pauseTimeout = null;
  }
  defaultPose(ref);
  setStatus('Avatar ready');
}

function processQueueStep() {
  if (!ref.pending || !ref.avatar) {
    return;
  }

  if (ref.animations.length === 0) {
    ref.pending = false;
    return;
  }

  const current = ref.animations[0];
  if (!current.length) {
    ref.flag = true;
    pauseTimeout = setTimeout(() => {
      ref.flag = false;
    }, ref.pause);
    ref.animations.shift();
    return;
  }

  if (ref.flag) {
    return;
  }

  if (current[0] && current[0][0] === 'add-text') {
    ref.animations.shift();
    return;
  }

  for (let i = 0; i < current.length;) {
    const [boneName, action, axis, limit, sign] = current[i];
    const bone = ref.avatar.getObjectByName(boneName);

    if (!bone || !bone[action]) {
      current.splice(i, 1);
      continue;
    }

    const value = bone[action][axis];
    if (sign === '+' && value < limit) {
      bone[action][axis] = Math.min(value + ref.speed, limit);
      i += 1;
    } else if (sign === '-' && value > limit) {
      bone[action][axis] = Math.max(value - ref.speed, limit);
      i += 1;
    } else {
      current.splice(i, 1);
    }
  }
}

function renderLoop() {
  requestAnimationFrame(renderLoop);
  processQueueStep();
  if (ref.renderer && ref.scene && ref.camera) {
    ref.renderer.render(ref.scene, ref.camera);
  }
}

function enqueueWord(word) {
  const sign = WORD_DICTIONARY[word];
  if (sign) {
    sign(ref);
    return;
  }
  fingerspell(word);
}

function fingerspell(word) {
  for (const letter of word) {
    const sign = LETTER_DICTIONARY[letter];
    if (sign) {
      sign(ref);
    }
  }
}

function normalizeText(text) {
  return text
    .toLowerCase()
    .replace(/[^a-z\s]/g, ' ')
    .split(/\s+/)
    .filter(Boolean);
}

function speak(text) {
  const words = normalizeText(text);
  for (const word of words) {
    enqueueWord(word);
  }
  if (!ref.pending) {
    ref.pending = true;
  }
}

async function setAvatarModel(modelName) {
  const normalized = modelName === 'xbot' ? 'xbot' : 'ybot';
  await loadAvatar(normalized);
}

window.speak = speak;
window.appendText = speak;
window.setAvatarModel = setAvatarModel;
window.resetAvatarQueue = () => {
  ref.animations = [];
  ref.pending = false;
  ref.flag = false;
};

window.addEventListener('resize', resize);
window.addEventListener('error', (event) => {
  setStatus(`Error: ${event.message}`);
});

setupScene();
renderLoop();
loadAvatar('ybot')
  .then(() => {
    window.signKitReady = true;
  })
  .catch((error) => {
    setStatus(`Avatar failed: ${error?.message || error}`);
  });
