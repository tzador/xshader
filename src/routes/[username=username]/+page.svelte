<script lang="ts">
  import { page } from "$app/state";
  import { authClient, signOut } from "$lib/auth.client";

  const session = authClient.useSession();
  const user:
    | {
        image?: string | null | undefined;
        username: string;
      }
    | undefined = $derived($session.data?.user) as any;
  const username = $derived(page.params.username.slice(1));
  const me = $derived(user?.username === username);
</script>
