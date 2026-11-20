// RN 순수 함수로 교차 테스트 기준값을 만든다(FL-036). `tool/sync_rn_cross.sh`가 RN 앱 폴더에서 RN의 tsx로 돌린다.
// 사용: tsx generate.mts <RN apps/mobile 경로> <출력 JSON>
// 입력은 고정 seed 난수라 RN 코드가 같으면 결과도 같다. 결과와 함께 RN 원본 파일 내용을 넣어,
// Flutter 테스트가 옆 RN 저장소와 달라졌는지(다시 만들어야 하는지) 볼 수 있게 한다.
import { readFileSync, writeFileSync } from 'node:fs';
import { createRequire } from 'node:module';
import { join } from 'node:path';
import { pathToFileURL } from 'node:url';

const [rnDir, outPath] = process.argv.slice(2);
if (!rnDir || !outPath) throw new Error('usage: generate.mts <rn apps/mobile dir> <out.json>');

/** 비교하는 RN 원본(apps/mobile 기준). 내용이 fixture에 들어간다. */
const SOURCES = [
  'src/lib/formatNumber.ts',
  'src/lib/formatAmount.ts',
  'src/charts/chartPeriods.ts',
  'src/charts/curveLayout.ts',
  'src/charts/priceLabels.ts',
] as const;

const load = (rel: string) => import(pathToFileURL(join(rnDir, rel)).href);
const [num, amount, periods, curve, labels] = await Promise.all(SOURCES.map(load));
const require = createRequire(join(rnDir, 'package.json'));
const d3Entry = require.resolve('d3-scale');
const d3 = await import(pathToFileURL(d3Entry).href);
// package.json은 exports에 없어 진입 파일 위쪽에서 직접 읽는다
const d3Version: string = JSON.parse(
  readFileSync(join(d3Entry.slice(0, d3Entry.lastIndexOf('/d3-scale/') + 10), 'package.json'), 'utf8'),
).version;

// 고정 seed LCG
let seed = 12345;
const rnd = () => {
  seed = (seed * 1103515245 + 12345) % 2147483648;
  return seed / 2147483648;
};
const pick = <T>(a: readonly T[]): T => a[Math.floor(rnd() * a.length)]!;

// 반올림 경계(x.5, 1.005처럼 2진수로 정확하지 않은 값)·부호·큰 수를 섞는다
const SPECIAL = [
  0, -0, 0.5, 1.5, 2.5, -0.5, -2.5, 0.005, 1.005, 1.045, 0.045, -0.004, -0.0049, 0.125, 0.375,
  999.995, 9999.5, 99999.95, 1e15, 123456789.123, -1234567.891, 5e-7, -5e-7, 0.0001, 86.845,
  2405.15, 1.0000000001,
];
function number(): number {
  const r = rnd();
  if (r < 0.2) return pick(SPECIAL);
  if (r < 0.5) return (rnd() - 0.5) * 10 ** Math.floor(rnd() * 8);
  if (r < 0.8)
    return (
      Math.round((rnd() - 0.5) * 10 ** Math.floor(rnd() * 7)) / 10 ** Math.floor(rnd() * 4) +
      pick([0, 0.005, 0.0005, 0.05])
    );
  return (rnd() - 0.5) * 10 ** Math.floor(rnd() * 16);
}

const cases: Record<string, unknown[]> = {};
const add = (key: string, row: unknown[]) => (cases[key] ??= []).push(row);

for (let i = 0; i < 1500; i++) {
  const v = number();
  const d = Math.floor(rnd() * 5);
  add('formatPrice', [v, d, num.formatPrice(v, d)]);
  add('formatChange', [v, d, num.formatChange(v, d)]);
  add('formatChangePct', [v, num.formatChangePct(v)]);
  const a = number() * pick([1, 1e3, 1e5, 1e8, 1e10]);
  add('compactAmount', [a, amount.compactAmount(a, 'eok'), amount.compactAmount(a, 'si')]);
}
for (let y = 2020; y < 2040; y++)
  for (let m = 1; m <= 12; m++) {
    const cm = `${y}-${String(m).padStart(2, '0')}`;
    add('contractMonth', [cm, num.formatContractMonth(cm), num.formatContractMonthShort(cm)]);
  }
for (let i = 0; i < 600; i++) {
  const total = pick([1, 5, 20, 41, 42, 63, 100, 126, 200, 252, 500, 756, Math.floor(rnd() * 1000) + 1]);
  const visible = pick([rnd() * total + 1, Math.floor(rnd() * 300) + 1, 59.4, 102.9, 145.4, 187.8]);
  add('nearestPeriod', [visible, total, periods.nearestPeriod(visible, total)]);
}
// y축 눈금: C-b는 RN niceTicks, C-a·C-c는 d3 linear·log 스케일. 자릿수는 모두 tickDecimals
for (let i = 0; i < 800; i++) {
  const base = pick([1, 3, 80, 2400, 0.5, 30000, 0.02, 12]) * (0.5 + rnd());
  const spread = pick([0.001, 0.01, 0.05, 0.1, 0.3, 1]) * rnd();
  const lo = base * (1 - spread);
  const hi = base * (1 + spread * rnd());
  const count = pick([4, 5, 6]);
  const max = Math.floor(rnd() * 5);
  const nice: number[] = curve.niceTicks(lo, hi, count);
  add('curveTicks', [lo, hi, count, max, nice, curve.tickDecimals(nice, max)]);
  const linear: number[] = d3.scaleLinear().domain([lo, hi]).ticks(count);
  add('linearTicks', [lo, hi, count, max, linear, curve.tickDecimals(linear, max)]);
  const log: number[] = d3.scaleLog().domain([lo, hi]).ticks(count);
  add('logTicks', [lo, hi, count, max, log, curve.tickDecimals(log, max)]);
}
for (let i = 0; i < 600; i++) {
  const n = Math.floor(rnd() * 7);
  const top = 10;
  const bottom = 60 + rnd() * 300;
  const height = pick([12, 14, 13.5]);
  const ys = Array.from({ length: n }, () => rnd() * (bottom + 40) - 20);
  const stacked = labels
    .stackLabels(
      ys.map((y, index) => ({ y, index })),
      height,
      top,
      bottom,
    )
    .map((l: { index: number; y: number }) => [l.index, l.y]);
  add('stackLabels', [ys, height, top, bottom, stacked]);
  const slot = pick([0, -1, rnd() * 40, 12.5]);
  const label = rnd() * 60;
  add('labelStride', [slot, label, curve.labelStride(slot, label)]);
  const x = rnd() * 400 - 50;
  const count = Math.floor(rnd() * 20);
  add('nearestSlot', [x, 10, slot, count, curve.nearestSlot(x, 10, slot, count)]);
  const s = { x0: rnd() * 100, y0: rnd() * 100, x1: rnd() * 100, y1: rnd() * 100 };
  if (rnd() < 0.2) s.x0 = s.x1; // 수직 선분
  const [l, r, t, b] = [rnd() * 100, rnd() * 100, rnd() * 100, rnd() * 100].sort((p, q) => p - q);
  add('segmentHitsBox', [
    [s.x0, s.y0, s.x1, s.y1],
    [l, r! + 1, t, b! + 1],
    curve.segmentHitsBox(s, l, r! + 1, t, b! + 1),
  ]);
}

const sources = Object.fromEntries(SOURCES.map((rel) => [rel, readFileSync(join(rnDir, rel), 'utf8')]));
writeFileSync(outPath, `${JSON.stringify({ d3ScaleVersion: d3Version, sources, cases })}\n`);
console.log(Object.entries(cases).map(([k, v]) => `${k} ${v.length}`).join(', '));
