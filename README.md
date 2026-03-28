# flowaccount

1. ใช้ Node.js LTS
ตอนนี้ node.js LTS version ล่าสุดจะเป็น v24 อ้างอิงจาก
https://nodejs.org/en/download

2. ติดตั้ง dependency แบบ production only
จะใช้เป็น npm install --omit=dev เพื่อให้ติดตั้งเฉพาะ dependency แบบ production อ้างอิงจาก
https://docs.npmjs.com/cli/v11/commands/npm-install

3. Image ต้องมีขนาดเล็ก ใช้ multi-stage build
ใช้ image เป็น type alpine เพื่อให้ docker มีขนาดที่เล็ก และ ใน docker จะแบ่งเป็น 2 stage คือ builder กับ production

4. App runด้วย non-root user
ทำการสร้าง user ชื่อว่า app_user เพื่อทำการ run app แทน root user

5. รองรับ graceful shutdown
จะทำการติดตั้ง tini เพื่อช่วยส่งสัญญาณให้ node.js ทำการ graceful shutdown อ้างอิงจาก
https://github.com/krallin/tini

6. เปิด port 3000
ทำการเปิด port 3000 ใน docker

7. Healthcheck เพื่อตรวจสอบว่า container ยังทํางานปกติ
- ใช้ endpoint /health ของ Node.js app
- ตรวจสอบทุก 30 วินาที, timeout 5 วินาที, retries 3 ครั้ง
จะทำการ curl ไปหา http://localhost:3000/health โดยจะตรวจตามเวลาที่ระบุ
