/**
 * Import function triggers from their respective submodules:
 *
 * import {onCall} from "firebase-functions/v2/https";
 * import {onDocumentWritten} from "firebase-functions/v2/firestore";
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

import {setGlobalOptions} from "firebase-functions";
import {onCall, HttpsError} from "firebase-functions/v2/https";
import {initializeApp} from "firebase-admin/app";
import {getFirestore} from "firebase-admin/firestore";
import {randomBytes} from "node:crypto";
// import {onRequest} from "firebase-functions/https";
// import * as logger from "firebase-functions/logger";

// Start writing functions
// https://firebase.google.com/docs/functions/typescript

// For cost control, you can set the maximum number of containers that can be
// running at the same time. This helps mitigate the impact of unexpected
// traffic spikes by instead downgrading performance. This limit is a
// per-function limit. You can override the limit for each function using the
// `maxInstances` option in the function's options, e.g.
// `onRequest({ maxInstances: 5 }, (req, res) => { ... })`.
// NOTE: setGlobalOptions does not apply to functions using the v1 API. V1
// functions should each use functions.runWith({ maxInstances: 10 }) instead.
// In the v1 API, each function can only serve one request per container, so
// this will be the maximum concurrent request count.

initializeApp();
setGlobalOptions({maxInstances: 10});
const ACCESS_CODE_CHARACTERS = "ABCDEFGHJKLMNPQRSTUVWXYZ23456789";
const ACCESS_CODE_LENGTH = 10;

/**
 * Generates a cryptographically secure property access code.
 *
 * @return {string} A random access code with the CN- prefix.
 */

function generateAccessCode(): string {
  const alphabetSize = ACCESS_CODE_CHARACTERS.length;
  const maxValidByte = Math.floor(256 / alphabetSize) * alphabetSize;

  let code = "CN-";

  while (code.length < ACCESS_CODE_LENGTH + 3) {
    const random = randomBytes(1)[0];

    if (random >= maxValidByte) {
      continue;
    }

    const index = random % alphabetSize;
    code += ACCESS_CODE_CHARACTERS[index];
  }

  return code;
}

/**
 * Verifies that a Firebase user has the admin role.
 *
 * @param {string} uid The authenticated user's UID.
 * @return {Promise<void>} Resolves when the user is an admin.
 */

async function verifyAdmin(uid: string): Promise<void> {
  const db = getFirestore();

  const userDocument = await db.collection("users").doc(uid).get();

  if (!userDocument.exists || userDocument.data()?.role !== "admin") {
    throw new HttpsError(
      "permission-denied",
      "You do not have permission to create properties."
    );
  }
}

export const createProperty = onCall(
  {maxInstances: 5},
  async (request) => {
    // 1. Verificar que el usuario haya iniciado sesión
    if (!request.auth) {
      throw new HttpsError(
        "unauthenticated",
        "You must be signed in to create a property."
      );
    }

    // 2. Obtener el UID desde Firebase Authentication
    const ownerId = request.auth.uid;

    // 3. Verificar que sea administrador
    await verifyAdmin(ownerId);

    const data = request.data;

    if (
      !data ||
  typeof data !== "object" ||
  Array.isArray(data)
    ) {
      throw new HttpsError(
        "invalid-argument",
        "Invalid property data."
      );
    }

    const allowedFields = [
      "name",
      "address",
      "wifiName",
      "wifiPassword",
      "checkIn",
      "checkOut",
    ];

    const receivedFields = Object.keys(data);

    if (
      receivedFields.some((field) => !allowedFields.includes(field))
    ) {
      throw new HttpsError(
        "invalid-argument",
        "Unexpected property fields."
      );
    }

    const {
      name,
      address,
      wifiName,
      wifiPassword,
      checkIn,
      checkOut,
    } = data;

    if (
      typeof name !== "string" ||
      name.trim().length === 0 ||
      typeof address !== "string" ||
      address.trim().length === 0 ||
      typeof wifiName !== "string" ||
      typeof wifiPassword !== "string" ||
      typeof checkIn !== "string" ||
      typeof checkOut !== "string"
    ) {
      throw new HttpsError(
        "invalid-argument",
        "Invalid property information."
      );
    }

    if (
      name.length > 100 ||
      address.length > 200 ||
      wifiName.length > 100 ||
      wifiPassword.length > 100 ||
      checkIn.length > 50 ||
      checkOut.length > 50
    ) {
      throw new HttpsError(
        "invalid-argument",
        "Property information exceeds the allowed length."
      );
    }


    const db = getFirestore();

    const propertyRef = db.collection("properties").doc();

    for (let attempt = 0; attempt < 5; attempt++) {
      const accessCode = generateAccessCode();

      const accessCodeRef = db
        .collection("property_access_codes")
        .doc(accessCode);

      const created = await db.runTransaction(async (transaction) => {
        const accessCodeDocument = await transaction.get(accessCodeRef);

        if (accessCodeDocument.exists) {
          return false;
        }

        transaction.create(propertyRef, {
          ownerId,
          accessCode,
          name: name.trim(),
          address: address.trim(),
          wifiName,
          wifiPassword,
          checkIn,
          checkOut,
        });

        transaction.create(accessCodeRef, {
          propertyId: propertyRef.id,
          ownerId,
        });

        return true;
      });

      if (created) {
        return {
          success: true,
          propertyId: propertyRef.id,
          accessCode,
        };
      }
    }

    throw new HttpsError(
      "resource-exhausted",
      "Unable to generate a unique access code. Please try again."
    );
  }
);

// export const helloWorld = onRequest((request, response) => {
//   logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });
