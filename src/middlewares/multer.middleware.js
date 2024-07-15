import multer from "multer";

const Storage = multer.diskStorage({
  destination: function (req, file, cb) {
    cb(null, "public/temp");
  },
  filename: function (req, file, cb) {
    const uniquesufix = Date.now() + "-" + Math.round(Math.random() * 1e9);
    cb(null, file.originalname + "-" + uniquesufix);
  },
});

const upload = multer({ storage: Storage });

export default upload;
